require "application_system_test_case"

class LandingTest < ApplicationSystemTestCase
  test "liść then robić" do
    visit root_url

    assert_equal "", page.find("input[name='query']").value

    fill_in "query", with: "liść"
    click_button "Search"

    assert_equal "liść", page.find("input[name='query']").value

    assert_text "leaf"
    assert_text "clip"

    assert_text "Z drzewa spadł już ostatni liść."
    assert_text "Liście traw dzielą się na pochwy i języczki."
    assert_text "W drzewie katalogów liśćmi są pliki."
    assert_text "Gdy wyznał jej, że od dłuższego czasu ma kochankę, dała mu z liścia w twarz."

    assert_css "img", count: 3

    assert_text "liść"
    assert_text "liście"
    assert_text "liścia"
    assert_text "liści"
    assert_text "liściowi"
    assert_text "liściom"
    assert_text "liść"
    assert_text "liście"
    assert_text "liściem"
    assert_text "liśćmi"
    assert_text "liściu"
    assert_text "liściach"
    assert_text "liściu"
    assert_text "liście"

    fill_in "query", with: "robić"
    click_button "Search"

    assert_equal "robić", page.find("input[name='query']").value

    assert_text "make"
    assert_text "create"
    assert_text "do"

    assert_text "W tej fabryce robią samochody."
    assert_text "Moja siostra dziś ma studniówkę i od rana robi makijaż."

    assert_css "img", count: 2

    assert_text 'robić'
    assert_text 'robię'
    assert_text 'robisz'
    assert_text 'robi'
    assert_text 'robimy'
    assert_text 'robicie'
    assert_text 'robią'
  end

  test "lisc gets autocorrected to liść" do
    visit root_url

    fill_in "query", with: "lisc"
    click_button "Search"

    assert_equal "liść", page.find("input[name='query']").value
    assert_text "lisc to liść"
  end

  test "LIść gets autocorrected to liść" do
    visit root_url

    fill_in "query", with: "LIść"
    click_button "Search"

    assert_equal "liść", page.find("input[name='query']").value
    assert_text "LIść to liść"
  end

  test "glod gets autocorrected to głód" do
    visit root_url

    fill_in "query", with: "glod"
    click_button "Search"

    assert_equal "głód", page.find("input[name='query']").value
    assert_text "glod to głód"
  end
end
