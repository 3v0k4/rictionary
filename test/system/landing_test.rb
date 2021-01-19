require "application_system_test_case"

class LandingTest < ApplicationSystemTestCase
  test "liść then ptak" do
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

    fill_in "query", with: "ptak"
    click_button "Search"

    assert_equal "ptak", page.find("input[name='query']").value

    assert_text "bird"

    assert_text "Ptak usiadł na parapecie."
    assert_text "Głośna zabawa dzieci płoszyła ptaki."
    assert_text "Świergot ptaków za oknem zapowiadał bliski świt"
    assert_text "Ptak mi wystaje z rozporka."

    assert_css "img", count: 1

    assert_text 'ptak'
    assert_text 'ptaki'
    assert_text 'ptaka'
    assert_text 'ptaków'
    assert_text 'ptakowi'
    assert_text 'ptakom'
    assert_text 'ptaka'
    assert_text 'ptaki'
    assert_text 'ptakiem'
    assert_text 'ptakami'
    assert_text 'ptaku'
    assert_text 'ptakach'
    assert_text 'ptaku'
    assert_text 'ptaki'
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

  test "robić then zrobić" do
    visit root_url

    fill_in "query", with: "robić"
    click_button "Search"

    assert_equal "robić", page.find("input[name='query']").value

    assert_text 'czasownik przechodni niedokonany dk. zrobić'
    assert_text 'czasownik nieprzechodni niedokonany dk. zrobić'
    assert_text 'czasownik zwrotny niedokonany robić się dk. zrobić się'

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

    fill_in "query", with: "zrobić"
    click_button "Search"

    assert_equal "zrobić", page.find("input[name='query']").value

    assert_text 'czasownik przechodni dokonany ndk. robić'
    assert_text 'czasownik zwrotny dokonany zrobić się ndk. robić się'

    assert_text "Oni zrobią wszystko dla pieniędzy."
    assert_text "Nie mogę uwierzyć, że ktoś mi zrobił takie świństwo."

    assert_text 'zrobić'
    assert_text 'zrobię'
    assert_text 'zrobisz'
    assert_text 'zrobi'
    assert_text 'zrobimy'
    assert_text 'zrobicie'
    assert_text 'zrobią'
  end
end
