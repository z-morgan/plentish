document.addEventListener('DOMContentLoaded', () => {
  const hamburger = document.getElementById('hamburger');
  const overlay = document.getElementById('overlay');
  const header = document.querySelector('header');
  
  hamburger.addEventListener('click', () => {
    overlay.classList.toggle('hidden');
    header.classList.toggle('hidden');
  });

  
});