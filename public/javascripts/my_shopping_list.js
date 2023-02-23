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

  async adjustQuantity(item_id, change) {
    const options = {
      method: 'PUT',
      headers: {'Content-type': 'application/x-www-form-urlencoded'},
      body: `change=${encodeURIComponent(change)}`
    };

    let response;
    try {
      response = await fetch(`/my-shopping-list/items/${item_id}`, options);
    } catch {
      alert('Could not communicate with the server at this time.');
    }
    return response.status;
  }

  async updateDeletedState(item_id, newState) {
    const options = {
      method: 'PUT',
      headers: {'Content-type': 'application/x-www-form-urlencoded'},
      body: `deleted=${newState}`
    };

    let response;
    try {
      response = await fetch(`/my-shopping-list/items/${item_id}`, options);
    } catch {
      alert('Could not communicate with the server at this time.');
    }
    return response.status;
  }
}

class ItemsData {
  constructor(rawItems) {
    this.rawItems = rawItems;
    [ this.shoppingList, this.deleted ] = this.partitionRawItems(rawItems);
    this.sortByDone(this.shoppingList);
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
    items.sort((a, b) => {
      if (a.done === b.done) {
        return 0;
      } else {
        return a.done ? 1 : -1;
      }
    });
  }

  updateQuantity(id, change) {
    this.rawItems.find(item => item.id === id).quantity += change;
  }

  getQuantity(id) {
    return this.rawItems.find(item => item.id === id).quantity
  }

  removeItem(id) {
    this.rawItems = this.rawItems.filter(item => item.id !== id);
    this.shoppingList = this.shoppingList.filter(item => item.id !== id);
  }

  updateDeletedState(id, newState) {
    const itemObj = this.rawItems.find(item => item.id === id);
    itemObj.deleted = newState;

    if (newState) {
      this.shoppingList = this.shoppingList.filter(item => item.id !== id);
      this.deleted.push(itemObj);
    } else {
      this.deleted = this.deleted.filter(item => item.id !== id);
      this.shoppingList.push(itemObj);
    }
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
    const html = this.templates['list-template']({items: this.itemsData.shoppingList});

    list.insertAdjacentHTML('beforeend', html);

    this.addQuantityAdjusters();
    this.addDeleteButtons();
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

    this.addShoppingListButtons();
  }

  addQuantityAdjusters() {
    const adjusters = document.querySelectorAll('.quantity-adjuster');
    for (let adjuster of adjusters) {
      adjuster.addEventListener('click', this.quantityAdjuster.bind(this));
    }
  }

  async quantityAdjuster(event) {
    event.stopPropagation();

    let change = -1;
    if (event.target.getAttribute('src') === '/images/up_arrow.png') {
      change = 1;
    }
    
    const itemLi = event.target.parentNode.parentNode;
    const itemId = itemLi.dataset.id;
    const status = await this.API.adjustQuantity(itemId, change);

    if (status === 204) {
      this.itemsData.updateQuantity(itemId, change);
      const newQuantity = this.itemsData.getQuantity(itemId);

      if (newQuantity > 0) {
        const quantSpan = itemLi.querySelector('span.quantity');
        quantSpan.textContent = String(newQuantity);
      } else {
        itemLi.remove();
        this.itemsData.removeItem(itemId);
      }
    } else {
      alert('Something went wrong... try that again after reloading the page.')
    }
  }

  addDeleteButtons() {
    const deleteButtons = document.querySelectorAll('.to-deleted');
    for (let button of deleteButtons) {
      button.addEventListener('click', this.updateDeletedState.bind(this, true));
    }
  }

  async updateDeletedState(newState, event) {
    const itemLi = event.target.parentNode;
    const itemId = itemLi.dataset.id;
    const status = await this.API.updateDeletedState(itemId, newState);
    
    if (status === 204) {
      this.itemsData.updateDeletedState(itemId, newState);
      itemLi.remove();
    } else {
      alert('Something went wrong... try that again after reloading the page.')
    }
  }

  addShoppingListButtons() {
    const shoppingListButtons = document.querySelectorAll('.to-shopping-list');
    for (let button of shoppingListButtons) {
      button.addEventListener('click', this.updateDeletedState.bind(this, false));
    }
  }
}

document.addEventListener('DOMContentLoaded', () => {
  new ShoppingList().init();
});
