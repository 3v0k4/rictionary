require 'test_helper'

class ParseHtmlTest < ActiveSupport::TestCase
  test 'it parses translations' do
    html = File.read('test/htmls/liść.html')

    actual = ParseHtml.new.call(html)

    assert_equal 2, actual.translations.size
    assert_includes actual.translations, 'leaf'
    assert_includes actual.translations, 'clip'
  end

  test 'it parses translations composed of multiple links' do
    html = File.read('test/htmls/para.html')

    actual = ParseHtml.new.call(html)

    assert_includes actual.translations, 'pair of'
  end

  test 'it skips staroangielski translations' do
    html = File.read('test/htmls/dom.html')

    actual = ParseHtml.new.call(html)

    assert_equal 2, actual.translations.size
    assert_includes actual.translations, 'house'
    assert_includes actual.translations, 'home'
  end

  test 'it skips styles in translations' do
    html = File.read('test/htmls/do_przodu.html')

    actual = ParseHtml.new.call(html)

    assert_includes actual.translations, 'ahead, forward / amer. forwards, skr. fwd, forth, frontward, onward / amer. onwards'
  end

  test 'it parses examples' do
    html = File.read('test/htmls/liść.html')

    actual = ParseHtml.new.call(html)

    assert_equal 4, actual.examples.size
    assert_includes actual.examples, 'Z drzewa spadł już ostatni liść.'
    assert_includes actual.examples, 'Liście traw dzielą się na pochwy i języczki.'
    assert_includes actual.examples, 'W drzewie katalogów liśćmi są pliki.'
    assert_includes actual.examples, 'Gdy wyznał jej, że od dłuższego czasu ma kochankę, dała mu z liścia w twarz.'
  end

  test 'it does not pick up examples from languages other than Polish' do
    html = File.read('test/htmls/para.html')

    actual = ParseHtml.new.call(html)

    assert_includes actual.examples, 'Ania i Jarek od pewnego czasu są parą.'
  end

  test 'it parses images and captions for liść' do
    html = File.read('test/htmls/liść.html')

    actual = ParseHtml.new.call(html)

    assert_equal 3, actual.images.size
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Focus_on_leaf.jpg/220px-Focus_on_leaf.jpg', caption: 'liść' }
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Porop_ruder_100306-0658_la.jpg/220px-Porop_ruder_100306-0658_la.jpg', caption: 'liść' }
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/9/93/Tree.example.png/220px-Tree.example.png', caption: 'liście D, F, G' }
  end

  test 'it parses images and captions for sikać' do
    html = File.read('test/htmls/sikać.html')

    actual = ParseHtml.new.call(html)

    assert_equal 3, actual.images.size
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Taking_a_Piss.jpg/220px-Taking_a_Piss.jpg', caption: 'mężczyzna sika na ogrodzenie' }
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Fresh_water_fountain.jpg/220px-Fresh_water_fountain.jpg', caption: 'woda sika' }
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/a/a9/US_Navy_090226-N-2610F-066_Boatswain%27s_Mate_2nd_Class_Chris_Fox%2C_from_Toledo%2C_Ohio%2C_hoses_down_the_bow_during_a_fresh-water_wash_down_aboard_the_Arleigh_Burke-class_guided-missile_destroyer_USS_Preble_%28DDG_88%29.jpg/220px-thumbnail.jpg', caption: 'marynarze sikają wodą na pokład' }
  end

  test 'it does not parse images in languages other than Polish' do
    html = File.read('test/htmls/spis.html')

    actual = ParseHtml.new.call(html)

    assert_equal 1, actual.images.size
  end

  test 'it parses the declination' do
    html = File.read('test/htmls/liść.html')

    actual = ParseHtml.new.call(html)

    expected = {
      nominative_singular: 'liść',
      nominative_plural: 'liście',
      genitive_singular: 'liścia',
      genitive_plural: 'liści',
      dative_singular: 'liściowi',
      dative_plural: 'liściom',
      accusative_singular: 'liść',
      accusative_plural: 'liście',
      instrumental_singular: 'liściem',
      instrumental_plural: 'liśćmi',
      locative_singular: 'liściu',
      locative_plural: 'liściach',
      vocative_singular: 'liściu',
      vocative_plural: 'liście',
    }
    assert_equal expected, actual.declination
  end

  test 'it parses only the first declination' do
    html = File.read('test/htmls/przypadek.html')

    actual = ParseHtml.new.call(html)

    assert_equal 'przypadek', actual.declination.fetch(:nominative_singular)
  end


  test 'it does not pick up the declination of languages other than Polish' do
    html = File.read('test/htmls/pot.html')

    actual = ParseHtml.new.call(html)

    assert_equal 'pot', actual.declination.fetch(:nominative_singular)
    assert_equal 'poty', actual.declination.fetch(:nominative_plural)
  end

  test 'when declination is missing it parses to nil' do
    actual = ParseHtml.new.call('')

    assert_nil actual.declination
  end

  test 'it does not pick up styles in declination' do
    html = File.read('test/htmls/cześć.html')

    actual = ParseHtml.new.call(html)

    expected = {
      nominative_singular: 'cześć',
      nominative_plural: 'czci',
      genitive_singular: 'czci',
      genitive_plural: 'czci',
      dative_singular: 'czci',
      dative_plural: 'czciom',
      accusative_singular: 'cześć',
      accusative_plural: 'czci',
      instrumental_singular: 'czcią',
      instrumental_plural: 'czciami',
      locative_singular: 'czci',
      locative_plural: 'czciach',
      vocative_singular: 'czci',
      vocative_plural: 'czci',
    }
    assert_equal expected, actual.declination
  end

  test 'it parses the declination maintaining spaces' do
    html = File.read('test/htmls/dziecko.html')

    actual = ParseHtml.new.call(html)

    expected = {
      nominative_singular: 'dziecko',
      nominative_plural: 'dzieci lub przest. reg. dziecka',
      genitive_singular: 'dziecka',
      genitive_plural: 'dzieci lub przest. reg. dziecek',
      dative_singular: 'dziecku',
      dative_plural: 'dzieciom lub przest. reg. dzieckom',
      accusative_singular: 'dziecko',
      accusative_plural: 'dzieci lub przest. reg. dziecka',
      instrumental_singular: 'dzieckiem',
      instrumental_plural: 'dziećmi lub przest. reg. dzieckami',
      locative_singular: 'dziecku',
      locative_plural: 'dzieciach lub przest. reg. dzieckach',
      vocative_singular: 'dziecko',
      vocative_plural: 'dzieci lub przest. reg. dziecka',
    }
    assert_equal expected, actual.declination
  end

  test 'it parses the conjugation for verb niedokonany' do
    html = File.read('test/htmls/robić.html')

    actual = ParseHtml.new.call(html)

    expected = {
      infinitive: 'robić',
      present: [ 'robię', 'robisz', 'robi', 'robimy', 'robicie', 'robią' ],
      future: [],
      past: {
        masculine: [ 'robiłem', 'robiłeś', 'robił', 'robiliśmy', 'robiliście', 'robili' ],
        feminine: [ 'robiłam', 'robiłaś', 'robiła', 'robiłyśmy', 'robiłyście', 'robiły' ],
        neuter: [ '', '', 'robiło', 'robiłyśmy', 'robiłyście', 'robiły' ],
      },
      imperative: [ 'niech robię', 'rób', 'niech robi', 'róbmy', 'róbcie', 'niech robią' ],
    }
    assert_equal expected, actual.conjugation
  end

  test 'it parses the conjugation for verb dokonany' do
    html = File.read('test/htmls/zrobić.html')

    actual = ParseHtml.new.call(html)

    expected = {
      infinitive: 'zrobić',
      present: [],
      future: [ 'zrobię', 'zrobisz', 'zrobi', 'zrobimy', 'zrobicie', 'zrobią' ],
      past: {
        masculine: [ 'zrobiłem', 'zrobiłeś', 'zrobił', 'zrobiliśmy', 'zrobiliście', 'zrobili' ],
        feminine: [ 'zrobiłam', 'zrobiłaś', 'zrobiła', 'zrobiłyśmy', 'zrobiłyście', 'zrobiły' ],
        neuter: [ '', '', 'zrobiło', 'zrobiłyśmy', 'zrobiłyście', 'zrobiły' ],
      },
      imperative: [ 'niech zrobię', 'zrób', 'niech zrobi', 'zróbmy', 'zróbcie', 'niech zrobią' ],
    }
    assert_equal expected, actual.conjugation
  end

  test 'when conjugation is missing it parses to nil' do
    actual = ParseHtml.new.call('')

    assert_nil actual.conjugation
  end

  test 'it parses only the first conjugation' do
    html = File.read('test/htmls/malować.html')

    actual = ParseHtml.new.call(html)

    assert_equal 'malować', actual.conjugation.fetch(:infinitive)
  end

  test 'it parses categories for malować' do
    html = File.read('test/htmls/malować.html')

    actual = ParseHtml.new.call(html)

    assert_equal 5, actual.categories.size
    assert_includes actual.categories, 'czasownik przechodni niedokonany dk. pomalować'
    assert_includes actual.categories, 'czasownik przechodni niedokonany dk. namalować'
    assert_includes actual.categories, 'czasownik przechodni niedokonany dk. umalować'
    assert_includes actual.categories, 'czasownik zwrotny niedokonany malować się dk. umalować się'
    assert_includes actual.categories, 'czasownik zwrotny niedokonany malować się dk. brak'
  end

  test 'it parses categories for wcisnąć' do
    html = File.read('test/htmls/wcisnąć.html')

    actual = ParseHtml.new.call(html)

    assert_equal 1, actual.categories.size
    assert_includes actual.categories, 'aspekt dokonany od: wciskać'
  end

  test 'it parses translations from Swedish' do
    html = File.read('test/htmls/skål.html')

    actual = ParseHtml.new.call(html)

    assert_equal ['język szwedzki'], actual.other_translations.keys
    assert_includes actual.other_translations['język szwedzki'], 'na zdrowie (przed wzniesieniem toastu)'
    assert_includes actual.other_translations['język szwedzki'], 'miska'
    assert_includes actual.other_translations['język szwedzki'], 'toast'
  end

  test 'it parses translations from other languages' do
    html = File.read('test/htmls/haus.html')

    actual = ParseHtml.new.call(html)

    assert_includes actual.other_translations.keys, 'język indonezyjski'
    assert_includes actual.other_translations.keys, 'język wilamowski'
    assert_includes actual.other_translations['język indonezyjski'], 'spragniony'
    assert_includes actual.other_translations['język wilamowski'], 'dom, sień'
  end

  test 'it skips Polish for other_translations' do
    html = File.read('test/htmls/sklep.html')

    actual = ParseHtml.new.call(html)

    assert_includes actual.other_translations.keys, 'język czeski'
    assert_includes actual.other_translations.keys, 'język kaszubski'
  end

  test "it skips styles in other_translations" do
    html = File.read('test/htmls/rosso.html')

    actual = ParseHtml.new.call(html)

    assert_includes actual.other_translations['język włoski'], "polit. czerwony, lewicowiec"
  end
end
