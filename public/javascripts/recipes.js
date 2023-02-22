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

// async function sendCreateRequest(recipe) {
//   const options = {
//     method: 'POST',
//     headers: {'Content-type': 'application/json; charset=utf-8'},
//     body: JSON.stringify(recipe),
//   };

//   let response;
//   try {
//     response = await fetch('/recipes', options);
//   } catch {
//     alert('Could not communicate with the server at this time.');
//   }
//   return response.status;
// }

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

  // newRecipeForm.addEventListener('submit', async (event) => {
  //   event.preventDefault();

  //   const formData = new FormData(event.currentTarget);
  //   const ingredientNames = formData.getAll('i-name');
  //   const quantities = formData.getAll('quantity');
  //   const units = formData.getAll('units');

  //   let ingredients = [];
  //   for (let i = 0; i < ingredientNames.length; i += 1) {
  //     ingredients.push({
  //       name: ingredientNames[i],
  //       quantity: quantities[i],
  //       units: units[i],
  //     });
  //   }

  //   const recipe = {
  //     name: formData.get('name'),
  //     ingredients,
  //     description: formData.get('description'),
  //   };

  //   await sendCreateRequest(recipe);
  // });
});


/*
get all of the values for each of the ingredients fields
iterate through all arrays by index, and build an object each time
collect remaining form fields into an object
add ingredients array to that object

*/