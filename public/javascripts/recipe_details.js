class APIInterface {
  async deleteRecipe(recipe_id) {
    let response;
    try {
      response = await fetch(`/recipes/${recipe_id}`, { method: 'DELETE' });
    } catch {
      alert('Could not communicate with the server at this time.');
    }
    return response.status;
  }

  async getSuggestions(prefix) {
    const qString = `?prefix=${encodeURIComponent(prefix)}`;

    let response;
    try {
      response = await fetch('/items' + qString, {method: 'GET'});
    } catch {
      return [];
    }
    return response.json();
  }
}

class RecipeDetails {
  constructor() {
    this.API = new APIInterface();
    this.templates = this.initializeTemplates();
    this.addEditRecipeFormBehaviors();
    this.addDeleteRecipeHandler();
    this.addNameFormatter();
    this.addNameSuggestions();
  }

  initializeTemplates() {
    const HTMLTemplates = {};
    const templates = document.querySelectorAll('[type="text/x-handlebars"]');
    for (let template of templates) {
      HTMLTemplates[template.id] = Handlebars.compile(template.innerHTML);
    }
    return HTMLTemplates;
  }

  addEditRecipeFormBehaviors() {
    const editButton = document.querySelector('#edit-button');
    const editRecipeForm = document.querySelector('#edit-recipe-form');
    const formOverlay = document.querySelector('#form-overlay');
  
    editButton.addEventListener('click', event => {
      event.preventDefault();
  
      editRecipeForm.classList.remove('hidden');
      formOverlay.classList.remove('hidden');
    });
  
    const ingredientsList = document.querySelector('#ingredients-list');
    const addIngredientButton = document.querySelector('form > a')
    addIngredientButton.addEventListener('click', event => {
      event.preventDefault();
  
      let nextNum = 1;
      const iNames = document.querySelectorAll('[name^=i-name]');
      if (iNames.length > 0) {
        nextNum = Number(iNames[iNames.length - 1].name.match(/\d+$/)[0]) + 1;
      }
  
      const newHTML = this.templates['ingredient-template']({ nextNum });
      ingredientsList.insertAdjacentHTML('beforeend', newHTML);
  
      const deleteButton = ingredientsList.lastElementChild.querySelector('img');
      deleteButton.addEventListener('click', event => {
        event.target.parentNode.remove();
      });
    });
  
    this.addDeleteListeners();
  
    const existingIngredientsHTML = ingredientsList.innerHTML;
    editRecipeForm.addEventListener('reset', () => {
      ingredientsList.innerHTML = existingIngredientsHTML
      this.addDeleteListeners();
      editRecipeForm.classList.add('hidden');
      formOverlay.classList.add('hidden');
    });
  }

  addDeleteListeners() {
    const ingredientsList = document.querySelector('#ingredients-list');
    const deleteButtons = ingredientsList.querySelectorAll('img');
    for (let button of deleteButtons) {
      button.addEventListener('click', event => {
        event.target.parentNode.remove();
      });
    }
  }

  addDeleteRecipeHandler() {
    const deleteButton = document.querySelector('#delete-button');
    const overlay = document.querySelector('#form-overlay');
    const confirmDeletePane = document.querySelector('#confirm-delete');
    const finalDeleteButton = document.querySelector('#final-delete');
    const backButton = document.querySelector('#go-back');
  
    deleteButton.addEventListener('click', event => {
      event.preventDefault();
  
      overlay.classList.remove('hidden');
      confirmDeletePane.classList.remove('hidden');
    });
  
    finalDeleteButton.addEventListener('click', async (event) => {
      event.preventDefault();
  
      let status = await this.API.deleteRecipe(event.target.dataset.id);
      if (status == 204) {
        event.target.nextElementSibling.click();
      } else {
        alert('Something went wrong... try that again after reloading the page.')
      }
    });
  
    backButton.addEventListener('click', event => {
      event.preventDefault();
  
      overlay.classList.add('hidden');
      confirmDeletePane.classList.add('hidden');
    });
  }

  addNameFormatter() {
    const ingredientsList = document.querySelector('#ingredients-list');
    ingredientsList.addEventListener('focusout', event => {
      if (!/i-name/.test(event.target.name)) return;
      if (event.target.value !== '') {
        event.target.value = this.formatName(event.target.value);
      }
    });
  }

  formatName(str) {
    if (str.length === 0) return '';
    str = str.trim().replace(/ +/g, ' ');
    return str.split(' ').map(word => {
      let tail = word.slice(1);
      return word[0].toUpperCase() + tail;
    }).join(' ');
  }

  addNameSuggestions() {
    const ingredientsList = document.querySelector('#ingredients-list');
    ingredientsList.addEventListener('keyup', async (event) => {
      if (!/i-name/.test(event.target.name)) return;
      if (event.key === 'ArrowUp' || event.key === 'ArrowDown') return;

      const suggestionsArea = event.target.parentNode.querySelector('div.suggestions-box');
      if (event.target.value === '') {
        suggestionsArea.innerHTML = '';
      } else {
        const suggestions = await this.API.getSuggestions(this.formatName(event.target.value));
        suggestionsArea.innerHTML = '';

        if (!Array.isArray(suggestions) || suggestions.length === 0) return;
        
        const newHTML = this.templates['suggestions-template']({ suggestions });
        suggestionsArea.insertAdjacentHTML('afterbegin', newHTML);
      }
    });

    ingredientsList.addEventListener('keydown', event => {
      if (!/i-name/.test(event.target.name)) return;
      
      if (event.key !== 'ArrowUp' && event.key !== 'ArrowDown') return;
      const suggestionsArea = event.target.parentNode.querySelector('div.suggestions-box');
      if (suggestionsArea.children.length === 0) return;

      const suggestionsList = suggestionsArea.firstElementChild;
      const highlighted = suggestionsList.querySelector('li.highlighted');
      
      if (event.key === 'ArrowDown') {
        if (!highlighted) {
          suggestionsList.firstElementChild.classList.add('highlighted');
        } else if (highlighted.nextElementSibling) {
          highlighted.classList.remove('highlighted');
          highlighted.nextElementSibling.classList.add('highlighted');
        } 
      } else if (event.key === 'ArrowUp') {
        if (!highlighted) return;
        event.preventDefault();
        highlighted.classList.remove('highlighted');
        if (highlighted.previousElementSibling) {
          highlighted.previousElementSibling.classList.add('highlighted');
        }
      }
    });

    ingredientsList.addEventListener('click', event => {
      if (!event.target.classList.contains('suggestion')
       && !event.target.parentNode.classList.contains('suggestion')) return;

      let li = event.target;
      if (event.target.tagName === 'SPAN') {
        li = event.target.parentNode;
      }

      const ingredient = li.parentNode.parentNode.parentNode;
      const nameField = ingredient.querySelector("[name^='i-name']");
      const unitsField = ingredient.querySelector("[name^='units-']");
      const quantityField = ingredient.querySelector("[name^='quantity-']");

      nameField.value = li.dataset.name;
      unitsField.value = li.dataset.units;

      const suggestionsArea = ingredient.querySelector('div.suggestions-box');
      suggestionsArea.innerHTML = '';
      quantityField.focus();
    });

    ingredientsList.addEventListener('focusout', event => {
      setTimeout(() => {
        if (!/i-name/.test(event.target.name)) return;

        const highlighted = event.target.parentNode.querySelector('li.highlighted');
        if (highlighted) {
          const ingredient = highlighted.parentNode.parentNode.parentNode;
          const nameField = ingredient.querySelector("[name^='i-name']");
          const unitsField = ingredient.querySelector("[name^='units-']");

          nameField.value = highlighted.dataset.name;
          unitsField.value = highlighted.dataset.units;
        }

        const suggestionsArea = event.target.parentNode.querySelector('div.suggestions-box');
        suggestionsArea.innerHTML = '';
      }, 100);
    });

    ingredientsList.addEventListener('mouseover', event => {
      if (!event.target.classList.contains('suggestion')) return;
      const highlighted = event.target.parentNode.querySelector('.highlighted');
      if (highlighted) {
        highlighted.classList.remove('highlighted');
      }
    });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  new RecipeDetails();
});