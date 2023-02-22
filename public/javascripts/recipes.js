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

document.addEventListener('DOMContentLoaded', () => {
  const recipes = document.querySelectorAll('li');
  for (let recipe of recipes) {
    recipe.addEventListener('click', event => {
      event.target.querySelector('a').click();
    });
  }


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

  const newRecipeButton = document.querySelector('#new-recipe');
  const newRecipeForm = document.querySelector('#new-recipe-form');
  const formOverlay = document.querySelector('#form-overlay');
  newRecipeButton.addEventListener('click', event => {
    event.preventDefault();

    newRecipeForm.classList.remove('hidden');
    formOverlay.classList.remove('hidden');
  });
});
