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
}

class RecipeDetails {
  constructor() {
    this.API = new APIInterface();
    this.templates = this.initializeTemplates();
    this.addEditRecipeFormBehaviors();
    this.addDeleteRecipeHandler();
    this.addNameFormatter();
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
      event.target.value = this.formatName(event.target.value);
    });
  }

  formatName(str) {
    return str.trim().split(' ').map(word => {
      let tail = word.slice(1);
      return word[0].toUpperCase() + tail;
    }).join(' ');
  }
}

document.addEventListener('DOMContentLoaded', () => {
  new RecipeDetails();
});