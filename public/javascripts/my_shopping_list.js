class APIInterface {
  async getItems() {
    const options = {
      method: 'GET',
      headers: {'Content-type': 'application/json; charset=utf-8'},
    };

    let response;
    try {
      response = await fetch('/my-shopping-list/items', options);
    } catch {
      alert('Could not communicate with the server at this time.');
    }
    return response.json();
  }
}

class ItemsData {
  constructor(rawItems) {
    console.log(rawItems);
    this.rawItems = rawItems;
    [ this.shoppingList, this.deleted ] = this.partitionRawItems(rawItems);
    this.shoppingList = this.sortByDone(this.shoppingList);
  }

  partitionRawItems(items) {
    return items.reduce((acc, item) => {
      if (item.deleted) {
        acc[1].push(item);
      } else {
        acc[0].push(item);
      }
      return acc;
    }, [[], []]);
  }

  sortByDone(items) {
    return items.sort((a, b) => {
      if (a.done === b.done) {
        return 0;
      } else {
        return a.done ? 1 : -1;
      }
    });
  }
}

class ShoppingList {
  constructor() {
    this.API = new APIInterface();
    this.templates = this.initializeTemplates();
  }

  async init() {
    this.itemsData = new ItemsData(await this.API.getItems());
    this.populateShoppingList();
    this.addEventHandlers();
  }

  initializeTemplates() {
    const HTMLTemplates = {};

    const templates = document.querySelectorAll('[type="text/x-handlebars"]');
    for (let template of templates) {
      HTMLTemplates[template.id] = Handlebars.compile(template.innerHTML);
    }

    const partials = document.querySelectorAll('[data-type="partial"]');
    for (let partial of partials) {
      Handlebars.registerPartial(partial.id, HTMLTemplates[partial.id]);
    }

    return HTMLTemplates;
  }

  populateShoppingList() {
    const list = document.querySelector('#shopping-list-pane ul');
    const html = this.templates['list-template']({items: this.itemsData.shoppingList})

    list.insertAdjacentHTML('beforeend', html)
  }

  addEventHandlers() {
    this.addListViewToggle();
  }

  addListViewToggle() {
    const deletedTab = document.getElementById('deleted-tab');
    const shoppingListTab = document.getElementById('my-shopping-list-tab');
    const addItemButton = document.getElementById('add-item-button');

    deletedTab.addEventListener('click', event => {
      event.preventDefault();

      deletedTab.classList.add('active');
      shoppingListTab.classList.remove('active');
      addItemButton.classList.add('hidden');

      const listItems = document.querySelectorAll('.list-item');
      for (let item of listItems) {
        item.remove();
      }

      this.populateDeleted();
    });

    shoppingListTab.addEventListener('click', event => {
      event.preventDefault();

      deletedTab.classList.remove('active');
      shoppingListTab.classList.add('active');
      addItemButton.classList.remove('hidden');

      const listItems = document.querySelectorAll('.list-item');
      for (let item of listItems) {
        item.remove();
      }

      this.populateShoppingList();
    });
  }

  populateDeleted() {
    const list = document.querySelector('#shopping-list-pane ul');
    const html = this.templates['deleted-template']({items: this.itemsData.deleted})

    list.insertAdjacentHTML('beforeend', html)
  }
}

document.addEventListener('DOMContentLoaded', () => {
  new ShoppingList().init();
});
