require "application_system_test_case"

class TranslationsTest < ApplicationSystemTestCase
  test "liść" do
    visit root_url

    fill_in "query", with: "liść"
    click_button "Search"

    assert_text "leaf"
    assert_text "clip"
  end
end
