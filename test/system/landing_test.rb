require "application_system_test_case"

class LandingTest < ApplicationSystemTestCase
  test "liść" do
    visit root_url

    fill_in "query", with: "liść"
    click_button "Search"

    assert_text "leaf"
    assert_text "clip"

    assert_text "Z drzewa spadł już ostatni liść."
    assert_text "Liście traw dzielą się na pochwy i języczki."
    assert_text "W drzewie katalogów liśćmi są pliki."
    assert_text "Gdy wyznał jej, że od dłuższego czasu ma kochankę, dała mu z liścia w twarz."

    assert_css "img", count: 3
  end
end
