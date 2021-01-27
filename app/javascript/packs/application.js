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
import '@trevoreyre/autocomplete-js/dist/style.css'

document.addEventListener("turbolinks:load", () => {
  const search = input => input.length === 0 ?
    Promise.resolve([]) :
    fetch(`/suggestions?query=${encodeURIComponent(input)}`).then(x => x.json())
  const onSubmit = () => document.getElementsByTagName('form')[0].submit()
  new Autocomplete('#autocomplete', { search, onSubmit })
})
