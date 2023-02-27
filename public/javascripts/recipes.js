
class APIInterface {
  async sendUpdateRequest(id, newState) {
    const options = {
      method: 'PUT',
      headers: {'Content-type': 'application/json; charset=utf-8'},
      body: JSON.stringify({selected: newState}),
    };
  
    let response;
    try {
      response = await fetch(`/recipes/${id}`, options);
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

class Recipes {
  constructor() {
    this.API = new APIInterface();
    this.templates = this.initializeTemplates();
    this.addRecipeDetailsHandlers();
    this.addRecipeSelectHandlers();
    this.addNewRecipeFormBehaviors();
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

  addRecipeDetailsHandlers() {
    const recipes = document.querySelectorAll('li');
    for (let recipe of recipes) {
      recipe.addEventListener('click', event => {
        event.target.querySelector('a').click();
      });
    }
  }

  addRecipeSelectHandlers() {
    const selectButtons = document.querySelectorAll('li img');
    for (let button of selectButtons) {
      button.addEventListener('click', async (event) => {
        event.stopPropagation();
  
        const id = event.target.dataset.id;
        const li = event.target.parentNode;
        if (event.target.dataset.selected) {
          let status = await this.API.sendUpdateRequest(id, false);
          if (status === 204) {
            event.target.removeAttribute('data-selected');
            event.target.setAttribute('src', '/images/circle.png');
            li.classList.remove('selected');
          } else {
            alert('Something went wrong... try that again after reloading the page.')
          }
        } else {
          let status = await this.API.sendUpdateRequest(id, true);
          if (status === 204) {
            event.target.setAttribute('data-selected', 'true');
            event.target.setAttribute('src', '/images/blue_checked_circle.png');
            li.classList.add('selected');
          } else {
            alert('Something went wrong... try that again after reloading the page.')
          }
        }
      });
    }
  }

  addNewRecipeFormBehaviors() {
    const newRecipeButton = document.querySelector('#new-recipe');
    const newRecipeForm = document.querySelector('#new-recipe-form');
    const formOverlay = document.querySelector('#form-overlay');
    
    newRecipeButton.addEventListener('click', event => {
      event.preventDefault();
  
      newRecipeForm.classList.remove('hidden');
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
  
    newRecipeForm.addEventListener('reset', () => {
      ingredientsList.textContent = '';
      newRecipeForm.classList.add('hidden');
      formOverlay.classList.add('hidden');
    });
  }

  addNameFormatter() {
    const ingredientsList = document.querySelector('#ingredients-list');
    ingredientsList.addEventListener('focusout', event => {
      if (!/i-name/.test(event.target.name)) return;
      event.target.value = this.formatName(event.target.value);
    });
  }
  
  formatName(str) {
    return str.trim().split(' ').map(word => {
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
  new Recipes();
});