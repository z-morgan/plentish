async function addToMyShoppingList(name, units) {
  const options = {
    method: 'POST',
    headers: {'Content-type': 'application/json; charset=utf-8'},
    body: JSON.stringify({ name, quantity: 1, units }),
  };

  let response;
  try {
    response = await fetch(`/my-shopping-list/items`, options);
  } catch {
    alert('Could not communicate with the server at this time.');
  }
  return response.status;
}

document.addEventListener('DOMContentLoaded', () => {
  const addButtons = document.querySelectorAll('main li a');
  for (let button of addButtons) {
    button.addEventListener('click', async (event) => {
      event.preventDefault();

      const name = event.target.dataset.name;
      const units = event.target.dataset.units;
      const status = await addToMyShoppingList(name, units);

      if (status === 200) {
        event.target.classList.add('checked');
        event.target.firstElementChild.setAttribute('src', '/images/green_check.png');
        // and remove this event listener
      } else {
        alert('Something went wrong... try that again after reloading the page.')
      }
    });
  }
});