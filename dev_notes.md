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

Extra features:
- print the shoppping list
- print the recipe
- detect duplicate items with different units, and provide a way to combine them into a single item
- restrict the number of login attempts within a certain period
- users can choose from a collection of icons to identify with their account
- upload a picture to go with a recipe, and it shows as a thumbnail on the recipes view

--------
# Pages/Views:
- Home Page:
  - Create Account and Sign-in buttons
  - A picture (or gif?) or the app in action (short description as placeholder)

- Create Account Page:
  - username/email
  - password

- Sign-in Page:
  - username/email
  - password

- My shopping list Page:
  - a list of items and their quantities (each items has:)
    - a checkbox where you can mark the item as obtained (whether before or while shopping)
      - checked items are moved to the bottom of the list
    - a quantity field
      - if the item was added from one or more recipes, the quantity is the total amount from the recipes
      - if duplicate items from different recipes have different units, treat them as seperate items
    - an edit button:
      - allows the user to change the name and quantity
      - if the item came from a recipe, warn the user that changing this will not affect the recipe (optional?)
    - a pantry button, which opens up a small view:
      - has a form to select how many items to move to the pantry

  - a new shopping list button, which after prompting the user to confirm:
    - archives the current shopping list
    - lets the user select which recipes to use
    - lets the user select archived lists from which to select individual items (optional... depends on difficulty of implementation)
    - refreshes My Shopping List with that data

- My recipes Page:
  - a list of the recipes
    - when one is clicked, views the recipes details
  - a button to add a new recipe

- Recipe details page:
  - displays all of the recipe's info
  - edit button allows changing any of the details
  - delete button allows deleting the recipe (after confirmation)

- New recipe page:
  - allows addition of the following details:
    - name
    - list of ingredients and their quantities
      - when adding ingredients, suggest existing ingredients (with units) with the same letters
      - allow deleting of ingredients on this page as well.
    - a description
  - add button
  - cancel button

- Archived shopping lists
  - a list of old shopping lists with the date each was created
  - clicking on a list displays the items in that list
  - clicking an item adds it to My shopping list


# Data Structures:

## back-end:

- recipe class
  - has a name
  - has a collection of ingredients
  - has a description

- shopping list class


## front-end:

- when adding or editing an ingredient's title, display a drop-down suggesting ingredients in 
  the database with the same permutation of letters
    if one of those is selected, populate the title and the quantity units
  - this will be an ajax operation

- when showing My shopping list:
  - have the done items already on the front end, so that clicking on the tab instantly reveals them.

- any CUD operations that do not involved changing the view use Ajax and don't reload the page
  - marking an item as done in My Shopping List
  - editing the quantity or title of an item in My Shopping List

- opening the new/edit recipe form is a front-end operation, but submission of it results in a full-page reload


# Steps:


Shopping List interactivity:

Click 'Add Item'
  - opens a small form which is used to add an item
    - name
    - quantity
    - units

  - submitting that form adds the item to the shopping list
    - makes Ajax request to create a new ingredient which is a member of the current shopping list

Click 'check box'
  - makes Ajax request to update the done state
  - replaces circle image with checked circle
  - sorts item to bottom of the list

Click 'Already have this'
  - makes Ajax request to update pantry state
  - removes ingredient from My Shopping List tab




Recipe Details page:

Add the ability to edit a recipe:
  click listener on edit button:
    - reveals a form and overlay, which covers the whole window
      - fields:
        - name
        - ingredients (for each)
          - name (text input)
          - quantity (number input)
          - units (select list)
          - delete button
        - new ingredient button
        - description text area
        - save button
        - cancel button
    
  - form submit:
    - update all of the recipe fields with the new values
    - delete all ingredients for that recipe
    - create new ingredients for each ingredient in the form
  
  - cancel listener:
    - resets form and hides form and overlay

- delete listener:
    prompts the user to confirm
    submits a delete request to the server, 
      which deletes the recipe and it's ingredients
      Then redirect user back to `/recipes`














Buglist:
- clicking fields in the new-recipe form generates JS errors on the console.








