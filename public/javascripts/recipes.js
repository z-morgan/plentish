function addRecipeDetailsHandlers() {
  const recipes = document.querySelectorAll('li');
  for (let recipe of recipes) {
    recipe.addEventListener('click', event => {
      event.target.querySelector('a').click();
    });
  }
}

function addRecipeSelectHandlers() {
  const selectButtons = document.querySelectorAll('li img');
  for (let button of selectButtons) {
    button.addEventListener('click', async (event) => {
      event.stopPropagation();

      const id = event.target.dataset.id;
      const li = event.target.parentNode;
      if (event.target.dataset.selected) {
        let status = await sendUpdateRequest(id, false);
        if (status === 204) {
          event.target.removeAttribute('data-selected');
          event.target.setAttribute('src', '/images/circle.png');
          li.classList.remove('selected');
        } else {
          alert('Something went wrong... try that again after reloading the page.')
        }
      } else {
        let status = await sendUpdateRequest(id, true);
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

async function sendUpdateRequest(id, newState) {
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

function addNewRecipeFormBehaviors() {
  const newRecipeButton = document.querySelector('#new-recipe');
  const newRecipeForm = document.querySelector('#new-recipe-form');
  const formOverlay = document.querySelector('#form-overlay');
  
  newRecipeButton.addEventListener('click', event => {
    event.preventDefault();

    newRecipeForm.classList.remove('hidden');
    formOverlay.classList.remove('hidden');
  });

  let ingredientTemplate = document.querySelector('[type="text/x-handlebars"]');
  ingredientTemplate = Handlebars.compile(ingredientTemplate.innerHTML);

  const ingredientsList = document.querySelector('#ingredients-list');
  const addIngredientButton = document.querySelector('form > a')
  addIngredientButton.addEventListener('click', event => {
    event.preventDefault();

    let nextNum = 1;
    const iNames = document.querySelectorAll('[name^=i-name]');
    if (iNames.length > 0) {
      nextNum = Number(iNames[iNames.length - 1].name.match(/\d+$/)[0]) + 1;
    }

    newHTML = ingredientTemplate({ nextNum });
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

document.addEventListener('DOMContentLoaded', () => {
  addRecipeDetailsHandlers();
  addRecipeSelectHandlers();
  addNewRecipeFormBehaviors();
});