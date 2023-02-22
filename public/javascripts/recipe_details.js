function addEditRecipeFormBehaviors() {
  const editButton = document.querySelector('#edit-button');
  const editRecipeForm = document.querySelector('#edit-recipe-form');
  const formOverlay = document.querySelector('#form-overlay');

  editButton.addEventListener('click', event => {
    event.preventDefault();

    editRecipeForm.classList.remove('hidden');
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

  addDeleteListeners();

  const existingIngredientsHTML = ingredientsList.innerHTML;
  editRecipeForm.addEventListener('reset', () => {
    ingredientsList.innerHTML = existingIngredientsHTML
    addDeleteListeners();
    editRecipeForm.classList.add('hidden');
    formOverlay.classList.add('hidden');
  });
}

function addDeleteListeners() {
  const ingredientsList = document.querySelector('#ingredients-list');
  const deleteButtons = ingredientsList.querySelectorAll('img');
  for (let button of deleteButtons) {
    button.addEventListener('click', event => {
      event.target.parentNode.remove();
    });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  addEditRecipeFormBehaviors();
});