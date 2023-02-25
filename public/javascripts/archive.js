document.addEventListener('DOMContentLoaded', () => {
  const lists = document.querySelectorAll('main li');
  for (let li of lists) {
    li.addEventListener('click', event => {
      event.stopPropagation();
      event.currentTarget.firstElementChild.click();
    }, true);
  }
});