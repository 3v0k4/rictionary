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
  addFontClass()
  setupAutocomplete()
  setupResetButton()
  setupShortcut('babla', 'b', 'click')
  setupShortcut('wiktionary', 'w', 'click')
  setupShortcut('query', 'f', 'select')
  persistQuery()
  showPersistedQueries()
  setupClearPersistedQueriesButton()
  setupAdjectiveDropdown()
  setupVerbDropdown()
})

const setupAutocomplete = () => {
  const search = input => input.length === 0 ?
    Promise.resolve([]) :
    fetch(`/suggestions?query=${encodeURIComponent(input)}`).then(x => x.json())
  const onSubmit = () => document.getElementsByTagName('form')[0].submit()
  const debounceTime = 300
  new Autocomplete('#autocomplete', { search, onSubmit, debounceTime })
}

const setupResetButton = () => {
  const resetButton = document.getElementById('reset')
  const queryInput = document.getElementById('query')
  const resetVisibility = () => {
    const display = queryInput.value.length > 0 ? 'inline-block' : 'none'
    resetButton.style.display = display
  }
  resetVisibility()
  queryInput.addEventListener('input', resetVisibility)
  resetButton.addEventListener('click', () => {
    queryInput.value = ''
    resetVisibility()
    queryInput.focus()
  })
}

const setupShortcut = (id, key, action) => {
  const link = document.getElementById(id)
  if (!link) { return }
  document.addEventListener('keypress', event => {
    if (event.key !== key) { return }
    if (document.activeElement !== document.getElementsByTagName('body')[0]) { return }
    link[action]()
    event.preventDefault()
  })
}

const PERSISTED_QUERIES_KEY = 'queries'
const PREVIOUS_QUERIES_ID = 'previous-queries'

const persistedQueries = () =>
  (window.localStorage.getItem(PERSISTED_QUERIES_KEY) || '')
    .split(',')
    .filter(x => x.length > 0)

const persistQuery = () => {
  const correctedQueryElement = document.getElementById('corrected-query')
  if (!correctedQueryElement) { return }
  const query = correctedQueryElement.textContent.trim()
  const toPersist = [...new Set([query].concat(persistedQueries()))].join(',')
  window.localStorage.setItem(PERSISTED_QUERIES_KEY, toPersist)
}

const showPersistedQueries = () => {
  const persisted = persistedQueries()
  if (persisted.length === 0) { return }
  const ul = document.getElementById('previous-queries').getElementsByTagName('ul')[0]
  const liTemplate = document.getElementById('template')
  persisted.forEach(query => {
    const li = liTemplate.cloneNode(true)
    const a = li.getElementsByTagName('a')[0]
    a.href = a.href.replace('QUERY', query)
    a.text = query
    li.style.display = 'list-item'
    ul.appendChild(li)
  })
  document.getElementById(PREVIOUS_QUERIES_ID).style.display = 'block'
}

const setupClearPersistedQueriesButton = () => {
  const button = document.getElementById('clear-persisted-queries')
  if (!button) { return }
  button.addEventListener('click', () => {
    document.getElementById(PREVIOUS_QUERIES_ID).style.display = 'none'
    window.localStorage.removeItem(PERSISTED_QUERIES_KEY)
  })
}

const addFontClass = () => {
  if (sessionStorage.fontsLoaded === "true") {
    document.documentElement.classList.add("fonts-loaded")
    return
  }

  if ("fonts" in document) {
    Promise.all([
      document.fonts.load('123px "Poppins"'),
    ]).then(() => {
      document.documentElement.classList.add("fonts-loaded")
      sessionStorage.fontsLoaded = "true"
    })
  }
}

const setupAdjectiveDropdown = () => {
  const select = document.getElementById('select-case')
  if (!select) { return }
  Array.prototype.slice.call(select.options).filter(x => x.selected).forEach(x => {
    document.getElementById(`declination-${x.value}`).style.display = 'block'
  })
  select.addEventListener('change', event => {
    document.querySelectorAll('.declination-split-table').forEach(x => x.style.display = 'none')
    document.getElementById(`declination-${event.target.value}`).style.display = 'block'
  })
}

const setupVerbDropdown = () => {
  const select = document.getElementById('select-conjugation')
  if (!select) { return }
  Array.prototype.slice.call(select.options).filter(x => x.selected).forEach(x => {
    document.getElementById(`conjugation-${x.value}`).style.display = 'block'
  })
  select.addEventListener('change', event => {
    document.querySelectorAll('.conjugation-split-table').forEach(x => x.style.display = 'none')
    document.getElementById(`conjugation-${event.target.value}`).style.display = 'block'
  })
}
