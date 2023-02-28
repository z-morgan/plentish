# Idea:
build a shopping list app with the following features:
- the ability to add a recipe by giving it a name and a list of ingredients
- the ability to select the recipies you want to shop for
- a list of all of the items you need to buy given the recipe selection, and the quantities
- the ability to easily remove ingredients from the list
- the ability to manually add items to the shopping list
- when manually adding ingredients or items, suggest things you have added before

boilerplate features:
- the ability to create an account and sign in


# Future work:
- make a demo route which allows full-usage of a auto-resetting demo account `/demo`
- select the number of times one will make a recipe per shopping list
- when starting a new list, let the user select recipes or archived items to initialize the list
- add the ability to combine items which have conversion factors for their units
- add the ability to upload images for recipes
- print the shoppping list
- print the recipe
- a settings page where a user can add additional units to be used in their account
- refactor backend to use the user id in the session (and maybe the current list id?) instead of the username
  - this would simpify a lot of the SQL queries a small amount
- change before filter so that instead of redirecting with a 302 if not signed in, use a 401 with an `WWW-Authenticate` header.
- add an html not found page and error page
- add email-based password recovery


# Steps:

- make a demo route which allows full-usage of a auto-resetting demo account `/demo`


# Units to add:









