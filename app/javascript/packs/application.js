// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import Autocomplete from "@trevoreyre/autocomplete-js"

document.addEventListener("turbolinks:load", () => {
  const search = input => input.length === 0 ?
    Promise.resolve([]) :
    fetch(`/suggestions?query=${encodeURIComponent(input)}`).then(x => x.json())
  const onSubmit = () => document.getElementsByTagName('form')[0].submit()
  const debounceTime = 300
  new Autocomplete('#autocomplete', { search, onSubmit, debounceTime })

  const resetButton = document.getElementById('reset');
  const queryInput = document.getElementById('query');
  const resetVisibility = () => {
    const display = queryInput.value.length > 0 ? 'inline-block' : 'none';
    resetButton.style.display = display;
  };
  resetVisibility();
  queryInput.addEventListener('input', resetVisibility);
  resetButton.addEventListener('click', () => {
    queryInput.value = '';
    resetVisibility();
    queryInput.focus();
  });

  setupShortcut('babla', 'b')
  setupShortcut('wiktionary', 'w')
})

const setupShortcut = (id, key) => {
  const link = document.getElementById(id)
  if (!link) { return }
  document.addEventListener('keypress', event => {
    if (event.key !== key) { return }
    link.click()
  })
}
