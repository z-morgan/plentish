
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
}

class Recipes {
  constructor() {
    this.API = new APIInterface();
    this.templates = this.initializeTemplates();
    this.addRecipeDetailsHandlers();
    this.addRecipeSelectHandlers();
    this.addNewRecipeFormBehaviors();
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
}

document.addEventListener('DOMContentLoaded', () => {
  new Recipes();
});