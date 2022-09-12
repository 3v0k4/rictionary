require 'test_helper'

class ParseWiktionaryHtmlTest < ActiveSupport::TestCase
  test 'it parses translations' do
    html = File.read('test/htmls/wiktionary/liść.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_equal 3, actual.translations.size
    assert_includes actual.translations, 'leaf'
    assert_includes actual.translations, 'leaf, leaf node'
    assert_includes actual.translations, 'clip'
  end

  test 'it parses translations composed of multiple links' do
    html = File.read('test/htmls/wiktionary/para.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_includes actual.translations, 'pair of'
  end

  test 'it skips staroangielski translations' do
    html = File.read('test/htmls/wiktionary/dom.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_equal 2, actual.translations.size
    assert_includes actual.translations, 'house'
    assert_includes actual.translations, 'home'
  end

  test 'it skips styles in translations' do
    html = File.read('test/htmls/wiktionary/do_przodu.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_includes actual.translations, 'ahead, forward / amer. forwards, skr. fwd, forth, frontward, onward / amer. onwards'
  end

  test 'it parses examples' do
    html = File.read('test/htmls/wiktionary/liść.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_equal 4, actual.examples.size
    assert_includes actual.examples, 'Z drzewa spadł już ostatni liść.'
    assert_includes actual.examples, 'Liście traw dzielą się na pochwy i języczki.'
    assert_includes actual.examples, 'W drzewie katalogów liśćmi są pliki.'
    assert_includes actual.examples, 'Gdy wyznał jej, że od dłuższego czasu ma kochankę, dała mu z liścia w twarz.'
  end

  test 'it does not pick up examples from languages other than Polish' do
    html = File.read('test/htmls/wiktionary/para.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_includes actual.examples, 'Ania i Jarek od pewnego czasu są parą.'
  end

  test 'it parses images and captions for liść' do
    html = File.read('test/htmls/wiktionary/liść.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_equal 3, actual.images.size
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Focus_on_leaf.jpg/220px-Focus_on_leaf.jpg', caption: 'liść' }
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Porop_ruder_100306-0658_la.jpg/220px-Porop_ruder_100306-0658_la.jpg', caption: 'liść' }
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/9/93/Tree.example.png/220px-Tree.example.png', caption: 'liście D, F, G' }
  end

  test 'it parses images and captions for sikać' do
    html = File.read('test/htmls/wiktionary/sikać.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_equal 3, actual.images.size
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Taking_a_Piss.jpg/220px-Taking_a_Piss.jpg', caption: 'mężczyzna sika na ogrodzenie' }
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Fresh_water_fountain.jpg/220px-Fresh_water_fountain.jpg', caption: 'woda sika' }
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/a/a9/US_Navy_090226-N-2610F-066_Boatswain%27s_Mate_2nd_Class_Chris_Fox%2C_from_Toledo%2C_Ohio%2C_hoses_down_the_bow_during_a_fresh-water_wash_down_aboard_the_Arleigh_Burke-class_guided-missile_destroyer_USS_Preble_%28DDG_88%29.jpg/220px-thumbnail.jpg', caption: 'marynarze sikają wodą na pokład' }
  end

  test 'it does not parse images in languages other than Polish' do
    html = File.read('test/htmls/wiktionary/spis.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_equal 1, actual.images.size
  end

  test 'it parses the declination for a noun' do
    html = File.read('test/htmls/wiktionary/liść.html')

    actual = ParseWiktionaryHtml.new.call(html)

    expected = {
      singular: {
        nominative: 'liść',
        genitive: 'liścia',
        dative: 'liściowi',
        accusative: 'liść',
        instrumental: 'liściem',
        locative: 'liściu',
        vocative: 'liściu',
      },
      plural: {
        nominative: 'liście',
        genitive: 'liści',
        dative: 'liściom',
        accusative: 'liście',
        instrumental: 'liśćmi',
        locative: 'liściach',
        vocative: 'liście',
      },
    }
    assert_equal expected, actual.declination
  end

  test 'it parses the declination for an adjective' do
    html = File.read('test/htmls/wiktionary/czerwony.html')

    actual = ParseWiktionaryHtml.new.call(html)

    expected = {
      singular: {
        masculine_personal: {
          nominative: 'czerwony',
          genitive: 'czerwonego',
          dative: 'czerwonemu',
          accusative: 'czerwonego',
          instrumental: 'czerwonym',
          locative: 'czerwonym',
          vocative: 'czerwony',
        },
        masculine_inanimate: {
          nominative: 'czerwony',
          genitive: 'czerwonego',
          dative: 'czerwonemu',
          accusative: 'czerwony',
          instrumental: 'czerwonym',
          locative: 'czerwonym',
          vocative: 'czerwony',
        },
        feminine: {
          nominative: 'czerwona',
          genitive: 'czerwonej',
          dative: 'czerwonej',
          accusative: 'czerwoną',
          instrumental: 'czerwoną',
          locative: 'czerwonej',
          vocative: 'czerwona',
        },
        neuter: {
          nominative: 'czerwone',
          genitive: 'czerwonego',
          dative: 'czerwonemu',
          accusative: 'czerwone',
          instrumental: 'czerwonym',
          locative: 'czerwonym',
          vocative: 'czerwone',
        },
      },
      plural: {
        masculine_personal: {
          nominative: 'czerwoni',
          genitive: 'czerwonych',
          dative: 'czerwonym',
          accusative: 'czerwonych',
          instrumental: 'czerwonymi',
          locative: 'czerwonych',
          vocative: 'czerwoni',
        },
        non_masculine_personal: {
          nominative: 'czerwone',
          genitive: 'czerwonych',
          dative: 'czerwonym',
          accusative: 'czerwone',
          instrumental: 'czerwonymi',
          locative: 'czerwonych',
          vocative: 'czerwone',
        },
      },
    }
    assert_equal expected, actual.declination
  end

  test 'it parses only the first declination' do
    html = File.read('test/htmls/wiktionary/przypadek.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_equal 'przypadek', actual.declination.dig(:singular, :nominative)
  end


  test 'it does not pick up the declination of languages other than Polish' do
    html = File.read('test/htmls/wiktionary/pot.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_equal 'pot', actual.declination.dig(:singular, :nominative)
    assert_equal 'poty', actual.declination.dig(:plural, :nominative)
  end

  test 'when declination is missing it parses to nil' do
    actual = ParseWiktionaryHtml.new.call('')

    assert_nil actual.declination
  end

  test 'it does not pick up styles in declination' do
    html = File.read('test/htmls/wiktionary/cześć.html')

    actual = ParseWiktionaryHtml.new.call(html)

    expected = {
      singular: {
        nominative: 'cześć',
        genitive: 'czci',
        dative: 'czci',
        accusative: 'cześć',
        instrumental: 'czcią',
        locative: 'czci',
        vocative: 'czci',
      },
      plural: {
        nominative: 'czci',
        genitive: 'czci',
        dative: 'czciom',
        accusative: 'czci',
        instrumental: 'czciami',
        locative: 'czciach',
        vocative: 'czci',
      },
    }
    assert_equal expected, actual.declination
  end

  test 'it parses the declination maintaining spaces' do
    html = File.read('test/htmls/wiktionary/dziecko.html')

    actual = ParseWiktionaryHtml.new.call(html)

    expected = {
      singular: {
        nominative: 'dziecko',
        genitive: 'dziecka',
        dative: 'dziecku',
        accusative: 'dziecko',
        instrumental: 'dzieckiem',
        locative: 'dziecku',
        vocative: 'dziecko',
      },
      plural: {
        nominative: 'dzieci lub przest. reg. dziecka',
        genitive: 'dzieci lub przest. reg. dziecek',
        dative: 'dzieciom lub przest. reg. dzieckom',
        accusative: 'dzieci lub przest. reg. dziecka',
        instrumental: 'dziećmi lub przest. reg. dzieckami',
        locative: 'dzieciach lub przest. reg. dzieckach',
        vocative: 'dzieci lub przest. reg. dziecka',
      },
    }
    assert_equal expected, actual.declination
  end

  test 'it parses the conjugation for verb niedokonany' do
    html = File.read('test/htmls/wiktionary/robić.html')

    actual = ParseWiktionaryHtml.new.call(html)

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
    html = File.read('test/htmls/wiktionary/zrobić.html')

    actual = ParseWiktionaryHtml.new.call(html)

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
    actual = ParseWiktionaryHtml.new.call('')

    assert_nil actual.conjugation
  end

  test 'it parses only the first conjugation' do
    html = File.read('test/htmls/wiktionary/malować.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_equal 'malować', actual.conjugation.fetch(:infinitive)
  end

  test 'it parses categories for malować' do
    html = File.read('test/htmls/wiktionary/malować.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_equal 5, actual.categories.size
    assert_includes actual.categories, 'czasownik przechodni niedokonany dk. pomalować'
    assert_includes actual.categories, 'czasownik przechodni niedokonany dk. namalować'
    assert_includes actual.categories, 'czasownik przechodni niedokonany dk. umalować'
    assert_includes actual.categories, 'czasownik zwrotny niedokonany malować się dk. umalować się'
    assert_includes actual.categories, 'czasownik zwrotny niedokonany malować się dk. brak'
  end

  test 'it parses categories for wcisnąć' do
    html = File.read('test/htmls/wiktionary/wcisnąć.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_equal 1, actual.categories.size
    assert_includes actual.categories, 'aspekt dokonany od: wciskać'
  end

  test 'it parses translations from Swedish' do
    html = File.read('test/htmls/wiktionary/skål.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_equal ['język szwedzki'], actual.other_translations.keys
    assert_includes actual.other_translations['język szwedzki'], 'misa, miseczka (na potrawy), czara (na napoje)'
    assert_includes actual.other_translations['język szwedzki'], 'toast'
  end

  test 'it parses translations from other languages' do
    html = File.read('test/htmls/wiktionary/haus.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_includes actual.other_translations.keys, 'język indonezyjski'
    assert_includes actual.other_translations.keys, 'język wilamowski'
    assert_includes actual.other_translations['język indonezyjski'], 'spragniony'
    assert_includes actual.other_translations['język wilamowski'], 'dom, sień'
  end

  test 'it skips Polish for other_translations' do
    html = File.read('test/htmls/wiktionary/sklep.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_includes actual.other_translations.keys, 'język czeski'
    assert_includes actual.other_translations.keys, 'język kaszubski'
    assert_not_includes actual.other_translations.keys, 'język polski'
  end

  test "it skips styles in other_translations" do
    html = File.read('test/htmls/wiktionary/rosso.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_includes actual.other_translations['język włoski'], "polit. czerwony, lewicowiec"
  end

  test 'it parses translations for improve' do
    html = File.read('test/htmls/wiktionary/improve.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_includes actual.other_translations.keys, 'język angielski'
    assert_includes actual.other_translations['język angielski'], 'poprawiać, polepszać, doskonalić, udoskonalać, ulepszać'
  end

  test 'it parses translations for run' do
    html = File.read('test/htmls/wiktionary/run.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_includes actual.other_translations.keys, 'język angielski'
    assert_includes actual.other_translations['język angielski'], 'inform. uruchomić'
  end

  test 'it removes empty other_translations from peer' do
    html = File.read('test/htmls/wiktionary/peer.html')

    actual = ParseWiktionaryHtml.new.call(html)

    assert_includes actual.other_translations.keys, 'język afrykanerski'
    assert_includes actual.other_translations['język afrykanerski'], 'bot. gruszka'
  end
end
