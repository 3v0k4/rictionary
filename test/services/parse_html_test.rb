require 'test_helper'

class ParseHtmlTest < ActiveSupport::TestCase
  test 'it parses translations' do
    actual = ParseHtml.new.call(<<-HTML)
<li id="mwUQ">
  angielski:
  (1.1) <a rel="mw:WikiLink" href="./leaf" title="leaf" id="mwUg">leaf</a>;
  (1.2) <a rel="mw:WikiLink" href="./leaf" title="leaf" id="mwUw">leaf</a>;
  (1.3) <a rel="mw:WikiLink" href="./clip" title="clip" id="mwVA">clip</a>
</li>
    HTML

    assert_equal 2, actual.translations.size
    assert_includes actual.translations, 'leaf'
    assert_includes actual.translations, 'clip'
  end

  test 'it parses translations composed of multiple links' do
    actual = ParseHtml.new.call(<<-HTML)
<li id="mwog">
  angielski:
  (1.21) <a rel="mw:WikiLink" href="./pair" title="pair" id="mwpQ">pair</a> <a rel="mw:WikiLink" href="./of" title="of" id="mwpg">of</a>
</li>
    HTML

    assert_equal 1, actual.translations.size
    assert_includes actual.translations, 'pair of'
  end


  test 'it parses examples' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język polski</span>
    </div>
  </div>
  <dl about="#mwt45">
    <dt><span class="field field-title fld-przyklady field-exampl" data-field="przyklady" data-section-links="exampl" style="display:block; clear:left;">przykłady<span typeof="mw:Entity">:</span></span></dt>
    <dd></dd>
    <dd>(1.1) <i><a rel="mw:WikiLink" href="./z" title="z">Z</a> <a rel="mw:WikiLink" href="./drzewo" title="drzewo">drzewa</a> <a rel="mw:WikiLink" href="./spaść" title="spaść">spadł</a> <a rel="mw:WikiLink" href="./już" title="już">już</a> <a rel="mw:WikiLink" href="./ostatni" title="ostatni">ostatni</a> <a rel="mw:WikiLink" href="./liść" title="liść">liść</a>.</i></dd>
    <dd>(1.1) <i><a rel="mw:WikiLink" href="./liść" title="liść">Liście</a> <a rel="mw:WikiLink" href="./trawa" title="trawa">traw</a> <a rel="mw:WikiLink" href="./dzielić_się" title="dzielić się" class="mw-redirect">dzielą się</a> <a rel="mw:WikiLink" href="./na" title="na">na</a> <a rel="mw:WikiLink" href="./pochwa" title="pochwa">pochwy</a> <a rel="mw:WikiLink" href="./i" title="i">i</a> <a rel="mw:WikiLink" href="./języczek" title="języczek">języczki</a>.</i></dd>
    <dd>(1.2) <i><a rel="mw:WikiLink" href="./w" title="w">W</a> <a rel="mw:WikiLink" href="./drzewo" title="drzewo">drzewie</a> <a rel="mw:WikiLink" href="./katalog" title="katalog">katalogów</a> <a rel="mw:WikiLink" href="./liść" title="liść">liśćmi</a> <a rel="mw:WikiLink" href="./być" title="być">są</a> <a rel="mw:WikiLink" href="./plik" title="plik">pliki</a>.</i></dd>
    <dd>(1.3) <i><a rel="mw:WikiLink" href="./gdy" title="gdy">Gdy</a> <a rel="mw:WikiLink" href="./wyznać" title="wyznać">wyznał</a> <a rel="mw:WikiLink" href="./ona" title="ona">jej</a>, <a rel="mw:WikiLink" href="./że" title="że">że</a> <a rel="mw:WikiLink" href="./od" title="od">od</a> <a rel="mw:WikiLink" href="./długi" title="długi">dłuższego</a> <a rel="mw:WikiLink" href="./czas" title="czas">czasu</a> <a rel="mw:WikiLink" href="./mieć" title="mieć">ma</a> <a rel="mw:WikiLink" href="./kochanka" title="kochanka">kochankę</a>, <a rel="mw:WikiLink" href="./dać" title="dać">dała</a> <a rel="mw:WikiLink" href="./on" title="on">mu</a> <a rel="mw:WikiLink" href="./z" title="z">z</a> <a rel="mw:WikiLink" href="./liść" title="liść">liścia</a> <a rel="mw:WikiLink" href="./w" title="w">w</a> <a rel="mw:WikiLink" href="./twarz" title="twarz">twarz</a>.</i></dd>
  </dl>
</div>
    HTML

    assert_equal 4, actual.examples.size
    assert_includes actual.examples, 'Z drzewa spadł już ostatni liść.'
    assert_includes actual.examples, 'Liście traw dzielą się na pochwy i języczki.'
    assert_includes actual.examples, 'W drzewie katalogów liśćmi są pliki.'
    assert_includes actual.examples, 'Gdy wyznał jej, że od dłuższego czasu ma kochankę, dała mu z liścia w twarz.'
  end

  test 'it does not pick up examples from languages other than Polish' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <div>
        <span>język polski</span>
      </div>
    </div>
    <dl about="#mwt63">
      <dt>
        <span class="field field-title fld-przyklady field-exampl" data-field="przyklady" data-section-links="exampl" style="display: block; clear: left;">przykłady<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
      <dd>
        (1.1)
        <i>
          <a rel="mw:WikiLink" href="./Ania" title="Ania">Ania</a> <a rel="mw:WikiLink" href="./i" title="i">i</a> <a rel="mw:WikiLink" href="./Jarek" title="Jarek">Jarek</a> <a rel="mw:WikiLink" href="./od" title="od">od</a>
          <a rel="mw:WikiLink" href="./pewien" title="pewien">pewnego</a> <a rel="mw:WikiLink" href="./czas" title="czas">czasu</a> <a rel="mw:WikiLink" href="./być" title="być">są</a> <a rel="mw:WikiLink" href="./para" title="para">parą</a>.
        </i>
      </dd>
    </dl>
  </div>

  <div>
    <div>
      <div>
        <span>język albański</span>
      </div>
    </div>
    <dl about="#mwt448">
      <dt>
        <span class="field field-title fld-przyklady field-exampl" data-field="przyklady" data-section-links="exampl" style="display: block; clear: left;">przykłady<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
      <dd>
        (1.1)
        <i><a rel="mw:WikiLink" href="./sot" title="sot">Sot</a> <a rel="mw:WikiLink" href="./fitoj" title="fitoj">fitova</a> <a rel="mw:WikiLink" href="./ca" title="ca">ca</a> <a rel="mw:WikiLink" href="./para" title="para">para</a>.</i> →
        <a rel="mw:WikiLink" href="./zarobić" title="zarobić">Zarobiłem</a> <a rel="mw:WikiLink" href="./dziś" title="dziś">dziś</a> <a rel="mw:WikiLink" href="./trochę" title="trochę">trochę</a>
        <b><a rel="mw:WikiLink" href="./pieniądz" title="pieniądz">pieniędzy</a></b>.
      </dd>
    </dl>
  </div>
</div>
    HTML

    assert_equal 1, actual.examples.size
    assert_includes actual.examples, 'Ania i Jarek od pewnego czasu są parą.'
  end

  test 'it parses images' do
    actual = ParseHtml.new.call(<<-HTML)
<section data-mw-section-id="1" id="mwAg">
  <figure class="mw-default-size" typeof="mw:Image/Thumb" id="mwBA"><a href="./Plik:Focus_on_leaf.jpg" id="mwBQ"><img resource="./Plik:Focus_on_leaf.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Focus_on_leaf.jpg/220px-Focus_on_leaf.jpg" data-file-width="512" data-file-height="384" data-file-type="bitmap" height="165" width="220" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Focus_on_leaf.jpg/330px-Focus_on_leaf.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Focus_on_leaf.jpg/440px-Focus_on_leaf.jpg 2x" id="mwBg"></a><figcaption id="mwBw">liść (1.1)</figcaption></figure>
  <figure class="mw-default-size" typeof="mw:Image/Thumb" id="mwCA"><a href="./Plik:Porop_ruder_100306-0658_la.jpg" id="mwCQ"><img resource="./Plik:Porop_ruder_100306-0658_la.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Porop_ruder_100306-0658_la.jpg/220px-Porop_ruder_100306-0658_la.jpg" data-file-width="1200" data-file-height="904" data-file-type="bitmap" height="166" width="220" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Porop_ruder_100306-0658_la.jpg/330px-Porop_ruder_100306-0658_la.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Porop_ruder_100306-0658_la.jpg/440px-Porop_ruder_100306-0658_la.jpg 2x" id="mwCg"></a><figcaption id="mwCw">liść (1.1)</figcaption></figure>
  <figure class="mw-default-size" typeof="mw:Image/Thumb" id="mwDA"><a href="./Plik:Tree.example.png" id="mwDQ"><img resource="./Plik:Tree.example.png" src="//upload.wikimedia.org/wikipedia/commons/thumb/9/93/Tree.example.png/220px-Tree.example.png" data-file-width="332" data-file-height="269" data-file-type="bitmap" height="178" width="220" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/9/93/Tree.example.png/330px-Tree.example.png 1.5x, //upload.wikimedia.org/wikipedia/commons/9/93/Tree.example.png 2x" id="mwDg"></a><figcaption id="mwDw">liście (1.2) <a rel="mw:WikiLink" href="./D" title="D" id="mwEA">D</a>, <a rel="mw:WikiLink" href="./F" title="F" id="mwEQ">F</a>, <a rel="mw:WikiLink" href="./G" title="G" id="mwEg">G</a></figcaption></figure>
</section>
    HTML

    assert_equal 3, actual.images.size
    assert_includes actual.images, '//upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Focus_on_leaf.jpg/220px-Focus_on_leaf.jpg'
    assert_includes actual.images, '//upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Porop_ruder_100306-0658_la.jpg/220px-Porop_ruder_100306-0658_la.jpg'
    assert_includes actual.images, '//upload.wikimedia.org/wikipedia/commons/thumb/9/93/Tree.example.png/220px-Tree.example.png'
  end

  test 'it parses the declination' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język polski</span>
    </div>
  </div>
  <table class="wikitable odmiana">
    <tbody>
      <tr>
        <th class="forma" style="font-weight:normal">
          <a rel="mw:WikiLink" href="./przypadek#pl" title="przypadek">przypadek</a>
        </th>
        <th style="font-weight:normal">
          <a rel="mw:WikiLink" href="./liczba_pojedyncza#pl" title="liczba pojedyncza">liczba pojedyncza</a>
        </th>
        <th style="font-weight:normal">
          <a rel="mw:WikiLink" href="./liczba_mnoga#pl" title="liczba mnoga">liczba mnoga</a>
        </th>
      </tr>
      <tr class="forma">
        <td class="forma">
          <span id="linkLanguage" title="polski"></span>
          <a rel="mw:WikiLink" href="./mianownik" title="mianownik">mianownik</a>
          <span id="linkLanguage" title=""></span>
        </td>
        <td class="mianownik">liść</td>
        <td class="mianownik">liście</td>
      </tr>
      <tr class="forma">
        <td class="forma">
          <span id="linkLanguage" title="polski"></span>
          <a rel="mw:WikiLink" href="./dopełniacz" title="dopełniacz">dopełniacz</a>
          <span id="linkLanguage" title=""></span>
        </td>
        <td>liścia</td>
        <td>liści</td>
      </tr>
      <tr class="forma">
        <td class="forma">
          <span id="linkLanguage" title="polski"></span>
          <a rel="mw:WikiLink" href="./celownik" title="celownik">celownik</a>
          <span id="linkLanguage" title=""></span>
        </td>
        <td>liściowi</td>
        <td>liściom</td>
      </tr>
      <tr class="forma">
        <td class="forma">
          <span id="linkLanguage" title="polski"></span>
          <a rel="mw:WikiLink" href="./biernik" title="biernik">biernik</a>
          <span id="linkLanguage" title=""></span>
        </td>
        <td>liść</td>
        <td>liście</td>
      </tr>
      <tr class="forma">
        <td class="forma">
          <span id="linkLanguage" title="polski"></span>
          <a rel="mw:WikiLink" href="./narzędnik" title="narzędnik">narzędnik</a>
          <span id="linkLanguage" title=""></span>
        </td>
        <td>liściem</td>
        <td>liśćmi</td>
      </tr>
      <tr class="forma">
        <td class="forma">
          <span id="linkLanguage" title="polski"></span>
          <a rel="mw:WikiLink" href="./miejscownik" title="miejscownik">miejscownik</a>
          <span id="linkLanguage" title=""></span>
        </td>
        <td>liściu</td>
        <td>liściach</td>
      </tr>
      <tr class="forma">
        <td class="forma">
          <span id="linkLanguage" title="polski"></span>
          <a rel="mw:WikiLink" href="./wołacz" title="wołacz">wołacz</a>
          <span id="linkLanguage" title=""></span>
        </td>
        <td>liściu</td>
        <td>liście</td>
      </tr>
    </tbody>
  </table>
</div>
    HTML

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
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język polski</span>
    </div>
  </div>
  <table class="wikitable odmiana">
    <tbody>
      <tr>
        <th class="forma" style="font-weight:normal">
          <a rel="mw:WikiLink" href="./przypadek#pl" title="przypadek">przypadek</a>
        </th>
        <th style="font-weight:normal">
          <a rel="mw:WikiLink" href="./liczba_pojedyncza#pl" title="liczba pojedyncza">liczba pojedyncza</a>
        </th>
        <th style="font-weight:normal">
          <a rel="mw:WikiLink" href="./liczba_mnoga#pl" title="liczba mnoga">liczba mnoga</a>
        </th>
      </tr>
      <tr class="forma">
        <td class="forma">
          <span id="linkLanguage" title="polski"></span>
          <a rel="mw:WikiLink" href="./mianownik" title="mianownik">mianownik</a>
          <span id="linkLanguage" title=""></span>
        </td>
        <td class="mianownik">liść</td>
        <td class="mianownik">liście</td>
      </tr>
    </tbody>
  </table>

  <table class="wikitable odmiana">
    <tbody>
      <tr>
        <th class="forma" style="font-weight:normal">
          <a rel="mw:WikiLink" href="./przypadek#pl" title="przypadek">przypadek</a>
        </th>
        <th style="font-weight:normal">
          <a rel="mw:WikiLink" href="./liczba_pojedyncza#pl" title="liczba pojedyncza">liczba pojedyncza</a>
        </th>
        <th style="font-weight:normal">
          <a rel="mw:WikiLink" href="./liczba_mnoga#pl" title="liczba mnoga">liczba mnoga</a>
        </th>
      </tr>
      <tr class="forma">
        <td class="forma">
          <span id="linkLanguage" title="polski"></span>
          <a rel="mw:WikiLink" href="./mianownik" title="mianownik">mianownik</a>
          <span id="linkLanguage" title=""></span>
        </td>
        <td class="mianownik">liść</td>
        <td class="mianownik">liście</td>
      </tr>
    </tbody>
  </table>
</div>
    HTML

    assert_equal 'liść', actual.declination.fetch(:nominative_singular)
  end


  test 'it does not pick up the declination of languages other than Polish' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <div>
        <span>język polski</span>
      </div>
    </div>
    <table class="wikitable odmiana">
      <tbody>
        <tr>
          <th class="forma" style="font-weight:normal">
            <a rel="mw:WikiLink" href="./przypadek#pl" title="przypadek">przypadek</a>
          </th>
          <th style="font-weight:normal">
            <a rel="mw:WikiLink" href="./liczba_pojedyncza#pl" title="liczba pojedyncza">liczba pojedyncza</a>
          </th>
          <th style="font-weight:normal">
            <a rel="mw:WikiLink" href="./liczba_mnoga#pl" title="liczba mnoga">liczba mnoga</a>
          </th>
        </tr>
        <tr class="forma">
          <td class="forma">
            <span id="linkLanguage" title="polski"></span>
            <a rel="mw:WikiLink" href="./mianownik" title="mianownik">mianownik</a>
            <span id="linkLanguage" title=""></span>
          </td>
          <td class="mianownik">para</td>
          <td class="mianownik">pary</td>
        </tr>
      </tbody>
    </table>
  </div>

  <div>
    <div>
      <span>język słowacki</span>
    </div>
  </div>
  <table class="wikitable odmiana">
    <tbody>
      <tr>
        <th class="forma" style="font-weight:normal">
          <a rel="mw:WikiLink" href="./przypadek#pl" title="przypadek">przypadek</a>
        </th>
        <th style="font-weight:normal">
          <a rel="mw:WikiLink" href="./liczba_pojedyncza#pl" title="liczba pojedyncza">liczba pojedyncza</a>
        </th>
        <th style="font-weight:normal">
          <a rel="mw:WikiLink" href="./liczba_mnoga#pl" title="liczba mnoga">liczba mnoga</a>
        </th>
      </tr>
      <tr class="forma">
        <td class="forma">
          <span id="linkLanguage" title="polski"></span>
          <a rel="mw:WikiLink" href="./mianownik" title="mianownik">mianownik</a>
          <span id="linkLanguage" title=""></span>
        </td>
        <td class="mianownik">para</td>
        <td class="mianownik">pary</td>
      </tr>
    </tbody>
  </table>
</div>
    HTML

    assert_equal 'para', actual.declination.fetch(:nominative_singular)
    assert_equal 'pary', actual.declination.fetch(:nominative_plural)
  end

  test 'when declination is missing it parses to nil' do
    actual = ParseHtml.new.call("")

    assert_nil actual.declination
  end

  test 'it parses the conjugation' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język polski</span>
    </div>
  </div>
  <table class="wikitable odmiana text-pl lang-pl fldt-odmiana" style="text-align: center; border: none;">
    <tbody class="lang-pl fldt-odmiana">
      <tr class="lang-pl fldt-odmiana">
        <th rowspan="2" colspan="2" class="lang-pl fldt-odmiana"><a href="/wiki/forma" title="forma" class="lang-pl fldt-odmiana">forma</a></th>
        <th colspan="3" class="lang-pl fldt-odmiana"><a href="/wiki/liczba_pojedyncza" title="liczba pojedyncza" class="lang-pl fldt-odmiana">liczba pojedyncza</a></th>
        <th colspan="3" class="lang-pl fldt-odmiana"><a href="/wiki/liczba_mnoga" title="liczba mnoga" class="lang-pl fldt-odmiana">liczba mnoga</a></th>
      </tr>
      <tr class="lang-pl fldt-odmiana">
        <th width="14%" class="lang-pl fldt-odmiana">
          <i class="lang-pl fldt-odmiana">1.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
          <span class="short-container lang-pl fldt-odmiana">
            <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
              <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
            </a>
          </span>
        </th>
        <th width="14%" class="lang-pl fldt-odmiana">
          <i class="lang-pl fldt-odmiana">2.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
          <span class="short-container lang-pl fldt-odmiana">
            <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
              <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
            </a>
          </span>
        </th>
        <th width="14%" class="lang-pl fldt-odmiana">
          <i class="lang-pl fldt-odmiana">3.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
          <span class="short-container lang-pl fldt-odmiana">
            <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
              <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
            </a>
          </span>
        </th>
        <th width="14%" class="lang-pl fldt-odmiana">
          <i class="lang-pl fldt-odmiana">1.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
          <span class="short-container lang-pl fldt-odmiana">
            <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
              <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
            </a>
          </span>
        </th>
        <th width="14%" class="lang-pl fldt-odmiana">
          <i class="lang-pl fldt-odmiana">2.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
          <span class="short-container lang-pl fldt-odmiana">
            <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
              <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
            </a>
          </span>
        </th>
        <th width="14%" class="lang-pl fldt-odmiana">
          <i class="lang-pl fldt-odmiana">3.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
          <span class="short-container lang-pl fldt-odmiana">
            <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
              <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
            </a>
          </span>
        </th>
      </tr>
      <tr class="lang-pl fldt-odmiana">
        <th colspan="2" class="lang-pl fldt-odmiana"><a href="/wiki/bezokolicznik" title="bezokolicznik" class="lang-pl fldt-odmiana">bezokolicznik</a></th>
        <td colspan="13" class="lang-pl fldt-odmiana"><b class="lang-pl fldt-odmiana">robić </b></td>
      </tr>
      <tr class="lang-pl fldt-odmiana">
        <th colspan="2" class="lang-pl fldt-odmiana"><a href="/wiki/czas_tera%C5%BAniejszy" title="czas teraźniejszy" class="lang-pl fldt-odmiana">czas teraźniejszy</a></th>
        <td class="lang-pl fldt-odmiana">robię</td>
        <td class="lang-pl fldt-odmiana">robisz</td>
        <td class="lang-pl fldt-odmiana">robi</td>
        <td class="lang-pl fldt-odmiana">robimy</td>
        <td class="lang-pl fldt-odmiana">robicie</td>
        <td class="lang-pl fldt-odmiana">robią</td>
      </tr>
      <tr class="lang-pl fldt-odmiana">
        <th rowspan="3" class="lang-pl fldt-odmiana"><a href="/wiki/czas_przesz%C5%82y" title="czas przeszły" class="lang-pl fldt-odmiana">czas przeszły</a></th>
        <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">m</i></th>
        <td class="lang-pl fldt-odmiana">robiłem</td>
        <td class="lang-pl fldt-odmiana">robiłeś</td>
        <td class="lang-pl fldt-odmiana">robił</td>
        <td class="lang-pl fldt-odmiana">robiliśmy</td>
        <td class="lang-pl fldt-odmiana">robiliście</td>
        <td class="lang-pl fldt-odmiana">robili</td>
      </tr>
      <tr class="lang-pl fldt-odmiana">
        <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">ż</i></th>
        <td class="lang-pl fldt-odmiana">robiłam</td>
        <td class="lang-pl fldt-odmiana">robiłaś</td>
        <td class="lang-pl fldt-odmiana">robiła</td>
        <td rowspan="2" class="lang-pl fldt-odmiana">robiłyśmy</td>
        <td rowspan="2" class="lang-pl fldt-odmiana">robiłyście</td>
        <td rowspan="2" class="lang-pl fldt-odmiana">robiły</td>
      </tr>
      <tr class="lang-pl fldt-odmiana">
        <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">n</i></th>
        <td class="lang-pl fldt-odmiana">
          <style data-mw-deduplicate="TemplateStyles:r6240426" class="lang-pl fldt-odmiana">
            .mw-parser-output .potential-form {
              opacity: 0.4;
              font-weight: normal;
              cursor: help;
            }
            .mw-parser-output .potential-form:hover {
              opacity: inherit;
            }
            @media print {
              .mw-parser-output .potential-form {
                font-style: italic;
                opacity: inherit;
              }
            }
          </style>
          <span class="potential-form lang-pl fldt-odmiana" title="forma potencjalna lub rzadka">robiłom </span>
        </td>
        <td class="lang-pl fldt-odmiana">
          <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" class="lang-pl fldt-odmiana" /><span class="potential-form lang-pl fldt-odmiana" title="forma potencjalna lub rzadka">robiłoś </span>
        </td>
        <td class="lang-pl fldt-odmiana">robiło</td>
      </tr>
      <tr class="lang-pl fldt-odmiana">
        <th colspan="2" class="lang-pl fldt-odmiana"><a href="/wiki/tryb_rozkazuj%C4%85cy" title="tryb rozkazujący" class="lang-pl fldt-odmiana">tryb rozkazujący</a></th>
        <td class="lang-pl fldt-odmiana"><a href="/wiki/niech" title="niech" class="lang-pl fldt-odmiana">niech</a> robię</td>
        <td class="lang-pl fldt-odmiana">rób</td>
        <td class="lang-pl fldt-odmiana"><a href="/wiki/niech" title="niech" class="lang-pl fldt-odmiana">niech</a> robi</td>
        <td class="lang-pl fldt-odmiana">róbmy</td>
        <td class="lang-pl fldt-odmiana">róbcie</td>
        <td class="lang-pl fldt-odmiana"><a href="/wiki/niech" title="niech" class="lang-pl fldt-odmiana">niech</a> robią</td>
      </tr>
      <tr class="lang-pl fldt-odmiana">
        <td colspan="8" style="padding: 0; border: none;" class="lang-pl fldt-odmiana">
          <table class="wikitable odmiana collapsible collapsed lang-pl fldt-odmiana" style="width: 100%; margin: 5px 0 0 0;">
            <tbody class="lang-pl fldt-odmiana">
              <tr class="lang-pl fldt-odmiana">
                <th colspan="8" style="font-weight: normal;" class="lang-pl fldt-odmiana"><span class="collapse-button" role="button">[ukryj▲]</span>&nbsp;pozostałe formy</th>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th rowspan="3" class="lang-pl fldt-odmiana"><a href="/wiki/czas_przysz%C5%82y" title="czas przyszły" class="lang-pl fldt-odmiana">czas przyszły</a></th>
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">m</i></th>
                <td class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będę</a> robił,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będę</a> robić
                </td>
                <td class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziesz</a> robił,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziesz</a> robić
                </td>
                <td class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będzie</a> robił,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będzie</a> robić
                </td>
                <td class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziemy</a> robili,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziemy</a> robić
                </td>
                <td class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziecie</a> robili,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziecie</a> robić
                </td>
                <td class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będą</a> robili,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będą</a> robić
                </td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">ż</i></th>
                <td class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będę</a> robiła,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będę</a> robić
                </td>
                <td class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziesz</a> robiła,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziesz</a> robić
                </td>
                <td class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będzie</a> robiła,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będzie</a> robić
                </td>
                <td rowspan="2" class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziemy</a> robiły,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziemy</a> robić
                </td>
                <td rowspan="2" class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziecie</a> robiły,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziecie</a> robić
                </td>
                <td rowspan="2" class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będą</a> robiły,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będą</a> robić
                </td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">n</i></th>
                <td class="lang-pl fldt-odmiana">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" class="lang-pl fldt-odmiana" />
                  <span class="potential-form lang-pl fldt-odmiana" title="forma potencjalna lub rzadka">
                    <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będę</a> robiło,<br class="lang-pl fldt-odmiana" />
                    <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będę</a> robić
                  </span>
                </td>
                <td class="lang-pl fldt-odmiana">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" class="lang-pl fldt-odmiana" />
                  <span class="potential-form lang-pl fldt-odmiana" title="forma potencjalna lub rzadka">
                    <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziesz</a> robiło,<br class="lang-pl fldt-odmiana" />
                    <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będziesz</a> robić
                  </span>
                </td>
                <td class="lang-pl fldt-odmiana">
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będzie</a> robiło,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">będzie</a> robić
                </td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th rowspan="3" class="lang-pl fldt-odmiana"><a href="/wiki/czas_zaprzesz%C5%82y" title="czas zaprzeszły" class="lang-pl fldt-odmiana">czas zaprzeszły</a></th>
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">m</i></th>
                <td class="lang-pl fldt-odmiana">robiłem <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">był</a></td>
                <td class="lang-pl fldt-odmiana">robiłeś <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">był</a></td>
                <td class="lang-pl fldt-odmiana">robił <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">był</a></td>
                <td class="lang-pl fldt-odmiana">robiliśmy <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byli</a></td>
                <td class="lang-pl fldt-odmiana">robiliście <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byli</a></td>
                <td class="lang-pl fldt-odmiana">robili <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byli</a></td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">ż</i></th>
                <td class="lang-pl fldt-odmiana">robiłam <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">była</a></td>
                <td class="lang-pl fldt-odmiana">robiłaś <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">była</a></td>
                <td class="lang-pl fldt-odmiana">robiła <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">była</a></td>
                <td rowspan="2" class="lang-pl fldt-odmiana">robiłyśmy <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">były</a></td>
                <td rowspan="2" class="lang-pl fldt-odmiana">robiłyście <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">były</a></td>
                <td rowspan="2" class="lang-pl fldt-odmiana">robiły <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">były</a></td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">n</i></th>
                <td class="lang-pl fldt-odmiana">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" class="lang-pl fldt-odmiana" />
                  <span class="potential-form lang-pl fldt-odmiana" title="forma potencjalna lub rzadka">robiłom <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">było</a></span>
                </td>
                <td class="lang-pl fldt-odmiana">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" class="lang-pl fldt-odmiana" />
                  <span class="potential-form lang-pl fldt-odmiana" title="forma potencjalna lub rzadka">robiłoś <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">było</a></span>
                </td>
                <td class="lang-pl fldt-odmiana">robiło <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">było</a></td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th colspan="2" class="lang-pl fldt-odmiana">
                  <a href="/wiki/forma_bezosobowa" title="forma bezosobowa" class="lang-pl fldt-odmiana">forma bezosobowa</a> <a href="/wiki/czas_przesz%C5%82y" title="czas przeszły" class="lang-pl fldt-odmiana">czasu przeszłego</a>
                </th>
                <td colspan="6" class="lang-pl fldt-odmiana">robiono</td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th rowspan="3" class="lang-pl fldt-odmiana"><a href="/wiki/tryb_przypuszczaj%C4%85cy" title="tryb przypuszczający" class="lang-pl fldt-odmiana">tryb przypuszczający</a></th>
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">m</i></th>
                <td width="14%" class="lang-pl fldt-odmiana">
                  robiłbym,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byłbym</a> robił
                </td>
                <td width="14%" class="lang-pl fldt-odmiana">
                  robiłbyś,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byłbyś</a> robił
                </td>
                <td width="14%" class="lang-pl fldt-odmiana">
                  robiłby,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byłby</a> robił
                </td>
                <td width="14%" class="lang-pl fldt-odmiana">
                  robilibyśmy,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">bylibyśmy</a> robili
                </td>
                <td width="14%" class="lang-pl fldt-odmiana">
                  robilibyście,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">bylibyście</a> robili
                </td>
                <td width="14%" class="lang-pl fldt-odmiana">
                  robiliby,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byliby</a> robili
                </td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">ż</i></th>
                <td class="lang-pl fldt-odmiana">
                  robiłabym,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byłabym</a> robiła
                </td>
                <td class="lang-pl fldt-odmiana">
                  robiłabyś,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byłabyś</a> robiła
                </td>
                <td class="lang-pl fldt-odmiana">
                  robiłaby,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byłaby</a> robiła
                </td>
                <td rowspan="2" class="lang-pl fldt-odmiana">
                  robiłybyśmy,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byłybyśmy</a> robiły
                </td>
                <td rowspan="2" class="lang-pl fldt-odmiana">
                  robiłybyście,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byłybyście</a> robiły
                </td>
                <td rowspan="2" class="lang-pl fldt-odmiana">
                  robiłyby,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byłyby</a> robiły
                </td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">n</i></th>
                <td class="lang-pl fldt-odmiana">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" class="lang-pl fldt-odmiana" />
                  <span class="potential-form lang-pl fldt-odmiana" title="forma potencjalna lub rzadka">
                    robiłobym,<br class="lang-pl fldt-odmiana" />
                    <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byłobym</a> robiło
                  </span>
                </td>
                <td class="lang-pl fldt-odmiana">
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" class="lang-pl fldt-odmiana" />
                  <span class="potential-form lang-pl fldt-odmiana" title="forma potencjalna lub rzadka">
                    robiłobyś,<br class="lang-pl fldt-odmiana" />
                    <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byłobyś</a> robiło
                  </span>
                </td>
                <td class="lang-pl fldt-odmiana">
                  robiłoby,<br class="lang-pl fldt-odmiana" />
                  <a href="/wiki/by%C4%87" title="być" class="lang-pl fldt-odmiana">byłoby</a> robiło
                </td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th rowspan="3" class="lang-pl fldt-odmiana"><a href="/wiki/imies%C5%82%C3%B3w_przymiotnikowy_czynny" title="imiesłów przymiotnikowy czynny" class="lang-pl fldt-odmiana">imiesłów przymiotnikowy czynny</a></th>
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">m</i></th>
                <td colspan="6" class="lang-pl fldt-odmiana">robiący, nierobiący</td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">ż</i></th>
                <td colspan="3" class="lang-pl fldt-odmiana">robiąca, nierobiąca</td>
                <td rowspan="2" colspan="3" class="lang-pl fldt-odmiana">robiące, nierobiące</td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">n</i></th>
                <td colspan="3" class="lang-pl fldt-odmiana">robiące, nierobiące</td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th rowspan="3" class="lang-pl fldt-odmiana"><a href="/wiki/imies%C5%82%C3%B3w_przymiotnikowy_bierny" title="imiesłów przymiotnikowy bierny" class="lang-pl fldt-odmiana">imiesłów przymiotnikowy bierny</a></th>
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">m</i></th>
                <td colspan="3" class="lang-pl fldt-odmiana">robiony</td>
                <td colspan="3" class="lang-pl fldt-odmiana">robieni</td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">ż</i></th>
                <td colspan="3" class="lang-pl fldt-odmiana">robiona</td>
                <td rowspan="2" colspan="3" class="lang-pl fldt-odmiana">robione</td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th class="lang-pl fldt-odmiana"><i class="lang-pl fldt-odmiana">n</i></th>
                <td colspan="3" class="lang-pl fldt-odmiana">robione</td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th colspan="2" class="lang-pl fldt-odmiana">
                  <a href="/wiki/imies%C5%82%C3%B3w_przys%C5%82%C3%B3wkowy_wsp%C3%B3%C5%82czesny" title="imiesłów przysłówkowy współczesny" class="lang-pl fldt-odmiana">imiesłów przysłówkowy współczesny</a>
                </th>
                <td colspan="6" class="lang-pl fldt-odmiana">robiąc, <a href="/wiki/nie" title="nie" class="lang-pl fldt-odmiana">nie</a> robiąc</td>
              </tr>
              <tr class="lang-pl fldt-odmiana" style="display: table-row;">
                <th colspan="2" class="lang-pl fldt-odmiana"><a href="/wiki/rzeczownik_odczasownikowy" title="rzeczownik odczasownikowy" class="lang-pl fldt-odmiana">rzeczownik odczasownikowy</a></th>
                <td colspan="6" class="lang-pl fldt-odmiana">
                  <a href="/wiki/robienie" title="robienie" class="lang-pl fldt-odmiana">robienie</a>, <a href="/wiki/nierobienie" title="nierobienie" class="lang-pl fldt-odmiana">nierobienie</a>
                </td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
    </tbody>
  </table>
</div>
    HTML

    expected = {
      infinitive: 'robić',
      present: [ 'robię', 'robisz', 'robi', 'robimy', 'robicie', 'robią' ],
      past: {
        masculine: [ 'robiłem', 'robiłeś', 'robił', 'robiliśmy', 'robiliście', 'robili' ],
        feminine: [ 'robiłam', 'robiłaś', 'robiła', 'robiłyśmy', 'robiłyście', 'robiły' ],
        neutral: [ '', '', 'robiło', 'robiłyśmy', 'robiłyście', 'robiły' ],
      },
      imperative: [ 'niech robię', 'rób', 'niech robi', 'róbmy', 'róbcie', 'niech robią' ],
    }
    assert_equal expected, actual.conjugation
  end

  test 'it does not pick up the conjugation from languages other than Polish' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <div>
        <span>język polski</span>
      </div>
    </div>
    <table class="wikitable odmiana text-pl lang-pl fldt-odmiana" style="text-align: center; border: none;">
      <tbody class="lang-pl fldt-odmiana">
        <tr class="lang-pl fldt-odmiana">
          <th rowspan="2" colspan="2" class="lang-pl fldt-odmiana"><a href="/wiki/forma" title="forma" class="lang-pl fldt-odmiana">forma</a></th>
          <th colspan="3" class="lang-pl fldt-odmiana"><a href="/wiki/liczba_pojedyncza" title="liczba pojedyncza" class="lang-pl fldt-odmiana">liczba pojedyncza</a></th>
          <th colspan="3" class="lang-pl fldt-odmiana"><a href="/wiki/liczba_mnoga" title="liczba mnoga" class="lang-pl fldt-odmiana">liczba mnoga</a></th>
        </tr>
        <tr class="lang-pl fldt-odmiana">
          <th width="14%" class="lang-pl fldt-odmiana">
            <i class="lang-pl fldt-odmiana">1.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
            <span class="short-container lang-pl fldt-odmiana">
              <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
                <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
              </a>
            </span>
          </th>
          <th width="14%" class="lang-pl fldt-odmiana">
            <i class="lang-pl fldt-odmiana">2.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
            <span class="short-container lang-pl fldt-odmiana">
              <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
                <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
              </a>
            </span>
          </th>
          <th width="14%" class="lang-pl fldt-odmiana">
            <i class="lang-pl fldt-odmiana">3.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
            <span class="short-container lang-pl fldt-odmiana">
              <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
                <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
              </a>
            </span>
          </th>
          <th width="14%" class="lang-pl fldt-odmiana">
            <i class="lang-pl fldt-odmiana">1.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
            <span class="short-container lang-pl fldt-odmiana">
              <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
                <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
              </a>
            </span>
          </th>
          <th width="14%" class="lang-pl fldt-odmiana">
            <i class="lang-pl fldt-odmiana">2.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
            <span class="short-container lang-pl fldt-odmiana">
              <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
                <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
              </a>
            </span>
          </th>
          <th width="14%" class="lang-pl fldt-odmiana">
            <i class="lang-pl fldt-odmiana">3.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
            <span class="short-container lang-pl fldt-odmiana">
              <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
                <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
              </a>
            </span>
          </th>
        </tr>
        <tr class="lang-pl fldt-odmiana">
          <th colspan="2" class="lang-pl fldt-odmiana"><a href="/wiki/bezokolicznik" title="bezokolicznik" class="lang-pl fldt-odmiana">bezokolicznik</a></th>
          <td colspan="13" class="lang-pl fldt-odmiana"><b class="lang-pl fldt-odmiana">robić </b></td>
        </tr>
      </tbody>
    </table>
  </div>

  <div>
    <div>
      <div>
        <span>język ryśki</span>
      </div>
    </div>
    <table class="wikitable odmiana text-pl lang-pl fldt-odmiana" style="text-align: center; border: none;">
      <tbody class="lang-pl fldt-odmiana">
        <tr class="lang-pl fldt-odmiana">
          <th rowspan="2" colspan="2" class="lang-pl fldt-odmiana"><a href="/wiki/forma" title="forma" class="lang-pl fldt-odmiana">forma</a></th>
          <th colspan="3" class="lang-pl fldt-odmiana"><a href="/wiki/liczba_pojedyncza" title="liczba pojedyncza" class="lang-pl fldt-odmiana">liczba pojedyncza</a></th>
          <th colspan="3" class="lang-pl fldt-odmiana"><a href="/wiki/liczba_mnoga" title="liczba mnoga" class="lang-pl fldt-odmiana">liczba mnoga</a></th>
        </tr>
        <tr class="lang-pl fldt-odmiana">
          <th width="14%" class="lang-pl fldt-odmiana">
            <i class="lang-pl fldt-odmiana">1.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
            <span class="short-container lang-pl fldt-odmiana">
              <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
                <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
              </a>
            </span>
          </th>
          <th width="14%" class="lang-pl fldt-odmiana">
            <i class="lang-pl fldt-odmiana">2.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
            <span class="short-container lang-pl fldt-odmiana">
              <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
                <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
              </a>
            </span>
          </th>
          <th width="14%" class="lang-pl fldt-odmiana">
            <i class="lang-pl fldt-odmiana">3.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
            <span class="short-container lang-pl fldt-odmiana">
              <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
                <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
              </a>
            </span>
          </th>
          <th width="14%" class="lang-pl fldt-odmiana">
            <i class="lang-pl fldt-odmiana">1.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
            <span class="short-container lang-pl fldt-odmiana">
              <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
                <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
              </a>
            </span>
          </th>
          <th width="14%" class="lang-pl fldt-odmiana">
            <i class="lang-pl fldt-odmiana">2.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
            <span class="short-container lang-pl fldt-odmiana">
              <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
                <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
              </a>
            </span>
          </th>
          <th width="14%" class="lang-pl fldt-odmiana">
            <i class="lang-pl fldt-odmiana">3.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" class="lang-pl fldt-odmiana" />
            <span class="short-container lang-pl fldt-odmiana">
              <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#O" class="mw-redirect lang-pl fldt-odmiana" title="Aneks:Skróty używane w Wikisłowniku">
                <span class="short-wrapper lang-pl fldt-odmiana" title="osoba" data-expanded="osoba"><span class="short-content lang-pl fldt-odmiana">os.</span></span>
              </a>
            </span>
          </th>
        </tr>
        <tr class="lang-pl fldt-odmiana">
          <th colspan="2" class="lang-pl fldt-odmiana"><a href="/wiki/bezokolicznik" title="bezokolicznik" class="lang-pl fldt-odmiana">bezokolicznik</a></th>
          <td colspan="13" class="lang-pl fldt-odmiana"><b class="lang-pl fldt-odmiana">ryśkić </b></td>
        </tr>
      </tbody>
    </table>
  </div>
</div>
    HTML

    assert_equal 'robić', actual.conjugation.fetch(:infinitive)
  end

  test 'when conjugation is missing it parses to nil' do
    actual = ParseHtml.new.call("")

    assert_nil actual.conjugation
  end

  test 'it parses only the first conjugation' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język polski</span>
    </div>
  </div>
  <dl class="text-pl">
    <table class="wikitable odmiana text-pl lang-pl fldt-odmiana" style="text-align: center; border: none;">
        <tr class="lang-pl fldt-odmiana">
          <th colspan="2" class="lang-pl fldt-odmiana"><a href="/wiki/bezokolicznik" title="bezokolicznik" class="lang-pl fldt-odmiana">bezokolicznik</a></th>
          <td colspan="13" class="lang-pl fldt-odmiana"><b class="lang-pl fldt-odmiana">robić </b></td>
        </tr>
    </table>
    <table class="wikitable odmiana text-pl lang-pl fldt-odmiana" style="text-align: center; border: none;">
      <tr class="lang-pl fldt-odmiana">
        <th colspan="2" class="lang-pl fldt-odmiana"><a href="/wiki/bezokolicznik" title="bezokolicznik" class="lang-pl fldt-odmiana">bezokolicznik</a></th>
        <td colspan="13" class="lang-pl fldt-odmiana"><b class="lang-pl fldt-odmiana">robić się</b></td>
      </tr>
    </table>
  </dl>
</div>
    HTML

    assert_equal 'robić', actual.conjugation.fetch(:infinitive)
  end

end
