/*
    Executes when the script is loaded on the page
 */
(function newFormField() {
    // Disable placeholder field if using label instead
    const label_as_placeholder_el = document.getElementById('label_as_placeholder')
    label_as_placeholder_el.addEventListener('change', (e) => {
        const placeholder_el = document.getElementById('placeholder')
        placeholder_el.disabled = e.target.checked;
    })

    // Monitor when the "Type" select element changes
    const select_field_type_el = document.getElementById('field_type');
    select_field_type_el.addEventListener('change', (e) => {
        const selected_type = e.target.options[e.target.selectedIndex];
        const has_children = selected_type.dataset.hasChildren;

        // Decide if we need to allow user to enter field children
        has_children == "true" ? showChildren() : hideChildren();
    })
}());

/*
   Shows the form field children fields in the DOM (for field types that require children)
 */
function showChildren() {
    // Set up DOM
    const childrenDiv = document.getElementById('form-field-children');
    childrenDiv.innerHTML = '<label class="form-label for="form_children">Options</label>'

    const childrenList = document.createElement('div');
    childrenList.id = 'form-field-children--list'
    childrenDiv.appendChild(childrenList);

    childrenDiv.innerHTML += `<button type="button" class="btn btn-primary mt-3" onClick=addChild()>Add another</button>`

    // Add first child
    addChild()
}

/*
   Hides the form field children fields in the DOM (for field types that don't allow children)
 */
function hideChildren() {
    // Reset DOM back to normal
    const childrenDiv = document.getElementById('form-field-children');
    childrenDiv.innerHTML = '';
}

/*
   Outputs a single child element
 */
function singleChild(i) {
    let div = document.createElement('div');
    div.className = "d-flex mb-2"
    div.setAttribute('data-id', i)
    div.innerHTML = `
        <input type="text" class="form-control" required id="form_children[${i}]" name="form_children[${i}]" placeholder="Option" />
        <button type="button" class="btn btn-link text-danger" onClick=deleteChild(${i})><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><!--!Font Awesome Free v7.0.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2025 Fonticons, Inc.--><path d="M183.1 137.4C170.6 124.9 150.3 124.9 137.8 137.4C125.3 149.9 125.3 170.2 137.8 182.7L275.2 320L137.9 457.4C125.4 469.9 125.4 490.2 137.9 502.7C150.4 515.2 170.7 515.2 183.2 502.7L320.5 365.3L457.9 502.6C470.4 515.1 490.7 515.1 503.2 502.6C515.7 490.1 515.7 469.8 503.2 457.3L365.8 320L503.1 182.6C515.6 170.1 515.6 149.8 503.1 137.3C490.6 124.8 470.3 124.8 457.8 137.3L320.5 274.7L183.1 137.4z"/></svg></button>
    `

    return div;
}

/*
   Adds a form field child to the DOM
 */
function addChild() {
    let children_list = document.getElementById('form-field-children--list');

    // Get the "id" of the last child and increment by one. 
    // It's ok if the id's aren't sequential. Once it hits the controller, we don't care anymore.
    // "IDs" are purely for adding and removing the field children
    let last_child = children_list.children[children_list.children.length - 1]
    let next_id = last_child && last_child.dataset ? parseInt(last_child.dataset.id) + 1 : 0;

    children_list.appendChild(singleChild(next_id))
}

/*
   Removes a form field child from the DOM
 */
function deleteChild(id) {
    // "IDs" are purely for adding and removing the field children, we don't care about them once it hits the controller.
    const element = document.querySelector(`[data-id="${id}"]`);
    element.remove();
}