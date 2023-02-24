class APIInterface {
  async getItems() {
    const options = {
      method: 'GET',
      headers: {'Content-type': 'application/json; charset=utf-8'}, // WHY IS THIS HERE?
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

  async updateDoneState(item_id, newState) {
    const options = {
      method: 'PUT',
      headers: {'Content-type': 'application/x-www-form-urlencoded'},
      body: `done=${newState}`
    };

    let response;
    try {
      response = await fetch(`/my-shopping-list/items/${item_id}`, options);
    } catch {
      alert('Could not communicate with the server at this time.');
    }
    return response.status;
  }

  async addItem(item) {
    const options = {
      method: 'POST',
      headers: {'Content-type': 'application/json; charset=utf-8'},
      body: JSON.stringify(item),
    };

    let response;
    try {
      response = await fetch(`/my-shopping-list/items`, options);
    } catch {
      alert('Could not communicate with the server at this time.');
    }
    return response.json();
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
    this.deleted = this.deleted.filter(item => item.id !== id);
  }

  updateDeletedState(id, newState) {
    const currentItem = this.rawItems.find(item => item.id === id);
    const existingItem = this.rawItems.find(item => {
      return item.name === currentItem.name 
          && item.units === currentItem.units 
          && item.deleted === newState;
    });

    if (existingItem) {
      currentItem.quantity += existingItem.quantity;
      this.removeItem(existingItem.id);
    }

    currentItem.deleted = newState;

    if (newState) {
      this.shoppingList = this.shoppingList.filter(item => item.id !== id);
      this.deleted.push(currentItem);
    } else {
      this.deleted = this.deleted.filter(item => item.id !== id);
      this.shoppingList.push(currentItem);
    }
  }

  updateDoneState(id, newState) {
    this.rawItems.find(item => item.id === id).done = newState;
    this.sortByDone(this.shoppingList);
  }

  addNewItem(newItem) {
    const existingItem = this.rawItems.find(item => item.id === newItem.id)
    if (existingItem) {
      let rawIndex = this.rawItems.indexOf(existingItem);
      let shoppingListIndex = this.shoppingList.indexOf(existingItem);
      this.rawItems[rawIndex] = newItem;
      this.shoppingList[shoppingListIndex] = newItem;
    } else {
      this.rawItems.push(newItem);
      this.shoppingList.unshift(newItem);
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
    this.addDoneButtons();
    this.resetAddItem();
  }

  addEventHandlers() {
    this.addListViewToggle();
    this.addAddItemBehavior();
  }

  addListViewToggle() {
    const deletedTab = document.getElementById('deleted-tab');
    const shoppingListTab = document.getElementById('my-shopping-list-tab');
    const addItemButton = document.getElementById('add-item');

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

  addDoneButtons() {
    const doneButtons = document.querySelectorAll('.done-button');
    for (let button of doneButtons) {
      button.addEventListener('click', this.updateDoneState.bind(this));
    }
  }

  async updateDoneState(event) {
    const itemLi = event.target.parentNode;
    const itemId = itemLi.dataset.id;
    const newState = event.target.getAttribute('src') === '/images/circle.png'
    const status = await this.API.updateDoneState(itemId, newState);
    
    if (status === 204) {
      this.itemsData.updateDoneState(itemId, newState);
      this.clearShoppingList();
      this.populateShoppingList();
    } else {
      alert('Something went wrong... try that again after reloading the page.')
    }
  }

  addAddItemBehavior() {
    const form = document.querySelector('#add-item-form');
    const addButton = document.querySelector('#add-item');
    addButton.addEventListener('click', event => {
      if (form.classList.contains('hidden')) {
        event.preventDefault();
        event.stopPropagation();
        addButton.firstElementChild.classList.add('hidden');
        form.classList.remove('hidden');
      }
    }, true);

    const cancel = document.querySelector('#add-item-controls input ~ input');
    cancel.addEventListener('click', this.resetAddItem);

    form.addEventListener('submit', async (event) => {
      event.preventDefault();

      const formData = new FormData(form);
      formData.set('name', this.formatName(formData.get('name')));
      let item = {};
      for (let [ key, value ] of formData) {
        item[key] = value
      }

      item = await this.API.addItem(item);
      
      if (Object.getPrototypeOf(item) === Object.prototype) {
        this.itemsData.addNewItem(item);
        this.clearShoppingList();
        this.populateShoppingList();
        form.reset();
      } else {
        alert('Something went wrong... try that again after reloading the page.')
      }
    });
  }

  clearShoppingList() {
    const listItems = document.querySelectorAll('li.list-item');
    for (let item of listItems) {
      item.remove();
    }
  }

  resetAddItem() {
    const form = document.querySelector('#add-item-form');
    const anchor = document.querySelector('#add-item-button');
    form.classList.add('hidden');
    anchor.classList.remove('hidden');
  }

  formatName(str) {
    return str.trim().split(' ').map(word => {
      let tail = word.slice(1);
      return word[0].toUpperCase() + tail;
    }).join(' ');
  }
}

document.addEventListener('DOMContentLoaded', () => {
  new ShoppingList().init();
});
