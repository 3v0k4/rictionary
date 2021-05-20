require "application_system_test_case"

class LandingTest < ApplicationSystemTestCase
  test "liść then ptak" do
    visit root_url

    assert_equal "", page.find("input[name='query']").value

    fill_in "query", with: "liść"
    click_button "Go"

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

    fill_in "query", with: ""
    fill_in "query", with: "ptak"
    click_button "Go"

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

  test "męskoosobowy takes translation from bab.la" do
    visit root_url

    assert_equal "", page.find("input[name='query']").value

    fill_in "query", with: "męskoosobowy"
    click_button "Go"

    assert_equal "męskoosobowy", page.find("input[name='query']").value
    assert_text 'masculine personal (gender)'
  end

  test "czerwony" do
    visit root_url

    assert_equal "", page.find("input[name='query']").value

    fill_in "query", with: "czerwony"
    click_button "Go"

    assert_equal "czerwony", page.find("input[name='query']").value

    assert_text 'czerwony'
    assert_text 'czerwonego'
    assert_text 'czerwonemu'
    assert_text 'czerwonego'
    assert_text 'czerwonym'
    assert_text 'czerwonym'
    assert_text 'czerwony'

    assert_text 'czerwony'
    assert_text 'czerwonego'
    assert_text 'czerwonemu'
    assert_text 'czerwony'
    assert_text 'czerwonym'
    assert_text 'czerwonym'
    assert_text 'czerwony'

    assert_text 'czerwona'
    assert_text 'czerwonej'
    assert_text 'czerwonej'
    assert_text 'czerwoną'
    assert_text 'czerwoną'
    assert_text 'czerwonej'
    assert_text 'czerwona'

    assert_text 'czerwone'
    assert_text 'czerwonego'
    assert_text 'czerwonemu'
    assert_text 'czerwone'
    assert_text 'czerwonym'
    assert_text 'czerwonym'
    assert_text 'czerwone'

    assert_text 'czerwoni'
    assert_text 'czerwonych'
    assert_text 'czerwonym'
    assert_text 'czerwonych'
    assert_text 'czerwonymi'
    assert_text 'czerwonych'
    assert_text 'czerwoni'

    assert_text 'czerwone'
    assert_text 'czerwonych'
    assert_text 'czerwonym'
    assert_text 'czerwone'
    assert_text 'czerwonymi'
    assert_text 'czerwonych'
    assert_text 'czerwone'
  end

  test "lisc gets autocorrected to liść" do
    visit root_url

    fill_in "query", with: "lisc"
    click_button "Go"

    assert_equal "liść", page.find("input[name='query']").value
    assert_text "liść"
  end

  test "LIść gets autocorrected to liść" do
    visit root_url

    fill_in "query", with: "LIść"
    click_button "Go"

    assert_equal "liść", page.find("input[name='query']").value
    assert_text "liść"
  end

  test "glod gets autocorrected to głód" do
    visit root_url

    fill_in "query", with: "glod"
    click_button "Go"

    assert_equal "głód", page.find("input[name='query']").value
    assert_text "głód"
  end

  test "blank spaces do not interfere" do
    visit root_url

    fill_in "query", with: " lisc "
    click_button "Go"

    assert_equal "liść", page.find("input[name='query']").value
    assert_text "liść"
  end

  test "robić then zrobić" do
    visit root_url

    fill_in "query", with: "robić"
    click_button "Go"

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

    fill_in "query", with: ""
    fill_in "query", with: "zrobić"
    click_button "Go"

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

  test "not found" do
    visit root_url

    assert_equal "", page.find("input[name='query']").value

    fill_in "query", with: "abc123"
    click_button "Go"

    assert_text /not found/i
  end

  test "fallback to babla" do
    visit root_url

    assert_equal "", page.find("input[name='query']").value

    fill_in "query", with: "podkrecic"
    click_button "Go"

    assert_link "bab.la"

    assert_text "crank up"
    assert_text "overclock"
    assert_text "gun"
    assert_text "pump up"
    assert_text "put spin on"
    assert_text "twirl"
    assert_text "spoon"
    assert_text "whack up"
  end

  test "link to wiktionary" do
    visit root_url

    fill_in "query", with: "lisc"
    click_button "Go"

    assert_link "Wiktionary"
  end

  test "when translations are missing but present on bab.la they are stolen" do
    visit root_url

    fill_in "query", with: "wyczesany"
    click_button "Go"

    assert_link "bab.la"
    assert_text "fanfuckingtastic"
  end

  test "multiword" do
    visit root_url

    fill_in "query", with: "do gory nogami"
    click_button "Go"

    assert_text "upside down"
  end

  test "multiword fallback to babla" do
    visit root_url

    fill_in "query", with: "na dół"
    click_button "Go"

    assert_link "bab.la"
  end

  test "skål in Swedish" do
    visit root_url

    fill_in "query", with: "skål"
    click_button "Go"

    assert_text "na zdrowie (przed wzniesieniem toastu)"
    assert_text "miska"
    assert_text "toast"
  end

  test "follows redirects" do
    visit root_url

    fill_in "query", with: "wahać się"
    click_button "Go"

    assert_text "hesitate"
  end

  test "persists queries" do
    visit root_url

    assert_no_text /previous queries/i

    fill_in "query", with: "halo"
    click_button "Go"

    assert_text /previous queries/i
    within "#previous-queries" do
      assert_text "halo"
    end

    visit root_url

    assert_text /previous queries/i
    within "#previous-queries" do
      assert_text "halo"
    end

    click_button "Clear"

    assert_no_text /previous queries/i
  end

  test "persists queries in anti-chronological order without duplicates" do
    visit root_url

    fill_in "query", with: ""
    fill_in "query", with: "halo"
    click_button "Go"

    all("#previous-queries a", count: 1)

    fill_in "query", with: ""
    fill_in "query", with: "sklep"
    click_button "Go"

    all("#previous-queries a", count: 2)

    fill_in "query", with: ""
    fill_in "query", with: "halo"
    click_button "Go"

    within "#previous-queries" do
      assert_link "halo", count: 1
    end

    within "#previous-queries" do
      links = all("a").map(&:text)
      assert_equal(["halo", "sklep"], links)
    end
  end
end
