document.addEventListener('DOMContentLoaded', () => {
  const registerForm = document.querySelector('#register');
  const signinForm = document.querySelector('#signin');
  const overlay = document.querySelector('#overlay');
  const cancelButtons = document.querySelectorAll('[type="reset"]');
  const registerButton = document.querySelector('#register-button');
  const signinButton = document.querySelector('#signin-button');

  for (let button of cancelButtons) {
    button.addEventListener('click', () => {
      overlay.classList.add('hidden');
      registerForm.classList.add('hidden');
      signinForm.classList.add('hidden');
    });
  }

  registerButton.addEventListener('click', event => {
    event.preventDefault();
    overlay.classList.remove('hidden');
    registerForm.classList.remove('hidden');
  });

  signinButton.addEventListener('click', event => {
    event.preventDefault();
    overlay.classList.remove('hidden');
    signinForm.classList.remove('hidden');
  });

  registerForm.addEventListener('submit', event => {
    const password1 = document.querySelector('#password1');
    const password2 = document.querySelector('#password2');
    if (password1.value !== password2.value) {
      event.preventDefault();
      password2.setCustomValidity('Passwords do not match.');
      password2.reportValidity();
    }
  });

  const password2 = document.querySelector('#password2');
  password2.addEventListener('focusout', event => {
    event.target.setCustomValidity('');
  });
});
