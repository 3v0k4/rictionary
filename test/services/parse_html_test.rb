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

  test 'it skips staroangielski' do
    actual = ParseHtml.new.call(<<-HTML)
<ul>
  <li id="mwog">
    angielski:
    (1.21) <a rel="mw:WikiLink" href="./pair" title="pair" id="mwpQ">pair</a> <a rel="mw:WikiLink" href="./of" title="of" id="mwpg">of</a>
  </li>
  <li id="mwog">
    staroangielski:
    (1.21) <a rel="mw:WikiLink" href="./pair" title="pair" id="mwpQ">pair</a> <a rel="mw:WikiLink" href="./of" title="of" id="mwpg">of</a>
  </li>
</ul>
    HTML

    assert_equal 1, actual.translations.size
    assert_includes actual.translations, 'pair of'
  end

  test 'it skips styles' do
    actual = ParseHtml.new.call(<<-HTML)
<ul class="text-other lang-pl fldt-tlumaczenia">
  <li class="text-other lang-pl fldt-tlumaczenia">
    angielski: <span class="term-num text-en lang-pl fldt-tlumaczenia term-lookup">(1.1)</span> <a href="/wiki/ahead#en" title="ahead" class="text-en lang-pl fldt-tlumaczenia">ahead</a>,
    <a href="/wiki/forward#en" title="forward" class="text-en lang-pl fldt-tlumaczenia">forward</a> /
    <style data-mw-deduplicate="TemplateStyles:r7574220" class="text-en lang-pl fldt-tlumaczenia">
      .mw-parser-output .short-container {
        font-style: italic;
        text-decoration: none;
      }
      .mw-parser-output .short-no-style {
        font-style: normal;
      }
      .mw-parser-output .short-container a:hover {
        color: #002bb8;
        text-decoration: underline;
      }
      .mw-parser-output .short-container a,
      .mw-parser-output .short-container a:visited {
        color: black;
      }
      .mw-parser-output .short-variant1 a,
      .mw-parser-output .short-variant1 a:visited {
        color: #002bb8;
      }
      .mw-parser-output .short-variant2 a,
      .mw-parser-output .short-variant2 a:visited {
        color: red;
      }
      .mw-parser-output .short-variant3 a,
      .mw-parser-output .short-variant3 a:visited {
        color: green;
      }
    </style>
    <span class="short-container text-en lang-pl fldt-tlumaczenia">
      <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#A" class="mw-redirect text-en lang-pl fldt-tlumaczenia" title="Aneks:Skróty używane w Wikisłowniku">
        <span class="short-wrapper text-en lang-pl fldt-tlumaczenia" title="amerykański angielski&nbsp;– angielskie „American English”" data-expanded="amerykański angielski">
          <span class="short-content text-en lang-pl fldt-tlumaczenia">amer.</span>
        </span>
      </a>
    </span>
    <a href="/wiki/forwards#en" title="forwards" class="text-en lang-pl fldt-tlumaczenia">forwards</a>, <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r7574220" class="text-en lang-pl fldt-tlumaczenia" />
    <span class="short-container text-en lang-pl fldt-tlumaczenia">
      <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#S" class="mw-redirect text-en lang-pl fldt-tlumaczenia" title="Aneks:Skróty używane w Wikisłowniku">
        <span class="short-wrapper text-en lang-pl fldt-tlumaczenia" title="skrót, skrótowiec, skrótowo" data-expanded="skrót, skrótowiec, skrótowo"><span class="short-content text-en lang-pl fldt-tlumaczenia">skr.</span></span>
      </a>
    </span>
    <a href="/w/index.php?title=fwd&amp;action=edit&amp;redlink=1#en" class="new text-en lang-pl fldt-tlumaczenia" title="fwd (strona nie istnieje)">fwd</a>,
    <a href="/wiki/forth#en" title="forth" class="text-en lang-pl fldt-tlumaczenia">forth</a>,
    <a href="/w/index.php?title=frontward&amp;action=edit&amp;redlink=1#en" class="new text-en lang-pl fldt-tlumaczenia" title="frontward (strona nie istnieje)">frontward</a>,
    <a href="/wiki/onward#en" title="onward" class="text-en lang-pl fldt-tlumaczenia">onward</a> / <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r7574220" class="text-en lang-pl fldt-tlumaczenia" />
    <span class="short-container text-en lang-pl fldt-tlumaczenia">
      <a href="/wiki/Aneks:Skr%C3%B3ty_u%C5%BCywane_w_Wikis%C5%82owniku#A" class="mw-redirect text-en lang-pl fldt-tlumaczenia" title="Aneks:Skróty używane w Wikisłowniku">
        <span class="short-wrapper text-en lang-pl fldt-tlumaczenia" title="amerykański angielski&nbsp;– angielskie „American English”" data-expanded="amerykański angielski">
          <span class="short-content text-en lang-pl fldt-tlumaczenia">amer.</span>
        </span>
      </a>
    </span>
    <a href="/wiki/onwards#en" title="onwards" class="text-en lang-pl fldt-tlumaczenia">onwards</a>; <span class="term-num text-en lang-pl fldt-tlumaczenia term-lookup">(2.1)</span>
    <a href="/wiki/go_ahead#en" title="go ahead" class="text-en lang-pl fldt-tlumaczenia">go ahead</a>!
  </li>
</ul>
    HTML

    assert_includes actual.translations, 'ahead, forward / amer. forwards, skr. fwd, forth, frontward, onward / amer. onwards'
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

  test 'it parses images and captions for liść' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język polski</span>
    </div>
  </div>
  <section data-mw-section-id="1" id="mwAg">
    <figure class="mw-default-size" typeof="mw:Image/Thumb" id="mwBA"><a href="./Plik:Focus_on_leaf.jpg" id="mwBQ"><img resource="./Plik:Focus_on_leaf.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Focus_on_leaf.jpg/220px-Focus_on_leaf.jpg" data-file-width="512" data-file-height="384" data-file-type="bitmap" height="165" width="220" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Focus_on_leaf.jpg/330px-Focus_on_leaf.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Focus_on_leaf.jpg/440px-Focus_on_leaf.jpg 2x" id="mwBg"></a><figcaption id="mwBw">liść (1.1)</figcaption></figure>
    <figure class="mw-default-size" typeof="mw:Image/Thumb" id="mwCA"><a href="./Plik:Porop_ruder_100306-0658_la.jpg" id="mwCQ"><img resource="./Plik:Porop_ruder_100306-0658_la.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Porop_ruder_100306-0658_la.jpg/220px-Porop_ruder_100306-0658_la.jpg" data-file-width="1200" data-file-height="904" data-file-type="bitmap" height="166" width="220" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Porop_ruder_100306-0658_la.jpg/330px-Porop_ruder_100306-0658_la.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Porop_ruder_100306-0658_la.jpg/440px-Porop_ruder_100306-0658_la.jpg 2x" id="mwCg"></a><figcaption id="mwCw">liść (1.1)</figcaption></figure>
    <figure class="mw-default-size" typeof="mw:Image/Thumb" id="mwDA"><a href="./Plik:Tree.example.png" id="mwDQ"><img resource="./Plik:Tree.example.png" src="//upload.wikimedia.org/wikipedia/commons/thumb/9/93/Tree.example.png/220px-Tree.example.png" data-file-width="332" data-file-height="269" data-file-type="bitmap" height="178" width="220" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/9/93/Tree.example.png/330px-Tree.example.png 1.5x, //upload.wikimedia.org/wikipedia/commons/9/93/Tree.example.png 2x" id="mwDg"></a><figcaption id="mwDw">liście (1.2) <a rel="mw:WikiLink" href="./D" title="D" id="mwEA">D</a>, <a rel="mw:WikiLink" href="./F" title="F" id="mwEQ">F</a>, <a rel="mw:WikiLink" href="./G" title="G" id="mwEg">G</a></figcaption></figure>
  </section>
</div>
    HTML

    assert_equal 3, actual.images.size
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Focus_on_leaf.jpg/220px-Focus_on_leaf.jpg', caption: 'liść' }
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Porop_ruder_100306-0658_la.jpg/220px-Porop_ruder_100306-0658_la.jpg', caption: 'liść' }
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/9/93/Tree.example.png/220px-Tree.example.png', caption: 'liście D, F, G' }
  end

  test 'it parses images and captions for sikać' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język polski</span>
    </div>
  </div>
  <section data-mw-section-id="1" id="mwAg">
    <figure class="mw-default-size" typeof="mw:Image/Thumb" id="mwBA">
      <a href="./Plik:Taking_a_Piss.jpg" id="mwBQ">
        <img
          resource="./Plik:Taking_a_Piss.jpg"
          src="//upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Taking_a_Piss.jpg/220px-Taking_a_Piss.jpg"
          data-file-width="870"
          data-file-height="678"
          data-file-type="bitmap"
          height="171"
          width="220"
          srcset="//upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Taking_a_Piss.jpg/330px-Taking_a_Piss.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Taking_a_Piss.jpg/440px-Taking_a_Piss.jpg 2x"
          id="mwBg"
        />
      </a>
      <figcaption id="mwBw">
        <a rel="mw:WikiLink" href="./mężczyzna" title="mężczyzna" id="mwCA">mężczyzna</a> sika (1.1) <a rel="mw:WikiLink" href="./na" title="na" id="mwCQ">na</a>
        <a rel="mw:WikiLink" href="./ogrodzenie" title="ogrodzenie" id="mwCg">ogrodzenie</a>
      </figcaption>
    </figure>
    <figure class="mw-default-size" typeof="mw:Image/Thumb" id="mwCw">
      <a href="./Plik:Fresh_water_fountain.jpg" id="mwDA">
        <img
          resource="./Plik:Fresh_water_fountain.jpg"
          src="//upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Fresh_water_fountain.jpg/220px-Fresh_water_fountain.jpg"
          data-file-width="1888"
          data-file-height="2841"
          data-file-type="bitmap"
          height="331"
          width="220"
          srcset="
            //upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Fresh_water_fountain.jpg/330px-Fresh_water_fountain.jpg 1.5x,
            //upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Fresh_water_fountain.jpg/440px-Fresh_water_fountain.jpg 2x
          "
          id="mwDQ"
        />
      </a>
      <figcaption id="mwDg"><a rel="mw:WikiLink" href="./woda" title="woda" id="mwDw">woda</a> sika (1.2)</figcaption>
    </figure>
    <figure class="mw-default-size" typeof="mw:Image/Thumb" id="mwEA">
      <a
        href="./Plik:US_Navy_090226-N-2610F-066_Boatswain's_Mate_2nd_Class_Chris_Fox,_from_Toledo,_Ohio,_hoses_down_the_bow_during_a_fresh-water_wash_down_aboard_the_Arleigh_Burke-class_guided-missile_destroyer_USS_Preble_(DDG_88).jpg"
        id="mwEQ"
      >
        <img
          resource="./Plik:US_Navy_090226-N-2610F-066_Boatswain's_Mate_2nd_Class_Chris_Fox,_from_Toledo,_Ohio,_hoses_down_the_bow_during_a_fresh-water_wash_down_aboard_the_Arleigh_Burke-class_guided-missile_destroyer_USS_Preble_(DDG_88).jpg"
          src="//upload.wikimedia.org/wikipedia/commons/thumb/a/a9/US_Navy_090226-N-2610F-066_Boatswain%27s_Mate_2nd_Class_Chris_Fox%2C_from_Toledo%2C_Ohio%2C_hoses_down_the_bow_during_a_fresh-water_wash_down_aboard_the_Arleigh_Burke-class_guided-missile_destroyer_USS_Preble_%28DDG_88%29.jpg/220px-thumbnail.jpg"
          data-file-width="2100"
          data-file-height="1406"
          data-file-type="bitmap"
          height="147"
          width="220"
          srcset="
            //upload.wikimedia.org/wikipedia/commons/thumb/a/a9/US_Navy_090226-N-2610F-066_Boatswain%27s_Mate_2nd_Class_Chris_Fox%2C_from_Toledo%2C_Ohio%2C_hoses_down_the_bow_during_a_fresh-water_wash_down_aboard_the_Arleigh_Burke-class_guided-missile_destroyer_USS_Preble_%28DDG_88%29.jpg/330px-thumbnail.jpg 1.5x,
            //upload.wikimedia.org/wikipedia/commons/thumb/a/a9/US_Navy_090226-N-2610F-066_Boatswain%27s_Mate_2nd_Class_Chris_Fox%2C_from_Toledo%2C_Ohio%2C_hoses_down_the_bow_during_a_fresh-water_wash_down_aboard_the_Arleigh_Burke-class_guided-missile_destroyer_USS_Preble_%28DDG_88%29.jpg/440px-thumbnail.jpg 2x
          "
          id="mwEg"
        />
      </a>
      <figcaption id="mwEw">
        <a rel="mw:WikiLink" href="./marynarz" title="marynarz" id="mwFA">marynarze</a> sikają (1.3) <a rel="mw:WikiLink" href="./woda" title="woda" id="mwFQ">wodą</a> <a rel="mw:WikiLink" href="./na" title="na" id="mwFg">na</a>
        <a rel="mw:WikiLink" href="./pokład" title="pokład" id="mwFw">pokład</a>
      </figcaption>
    </figure>
  </section>
</div>
    HTML

    assert_equal 3, actual.images.size
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Taking_a_Piss.jpg/220px-Taking_a_Piss.jpg', caption: 'mężczyzna sika na ogrodzenie' }
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Fresh_water_fountain.jpg/220px-Fresh_water_fountain.jpg', caption: 'woda sika' }
    assert_includes actual.images, { url: '//upload.wikimedia.org/wikipedia/commons/thumb/a/a9/US_Navy_090226-N-2610F-066_Boatswain%27s_Mate_2nd_Class_Chris_Fox%2C_from_Toledo%2C_Ohio%2C_hoses_down_the_bow_during_a_fresh-water_wash_down_aboard_the_Arleigh_Burke-class_guided-missile_destroyer_USS_Preble_%28DDG_88%29.jpg/220px-thumbnail.jpg', caption: 'marynarze sikają wodą na pokład' }
  end

  test 'it does not parse images in other languages' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język szwedzki</span>
    </div>
  </div>
  <section data-mw-section-id="1" id="mwAg">
    <figure class="mw-default-size" typeof="mw:Image/Thumb" id="mwug"><a href="./Plik:The_fireplace-RS.jpg" id="mwuw"><img resource="./Plik:The_fireplace-RS.jpg" src="//upload.wikimedia.org/wikipedia/commons/thumb/9/94/The_fireplace-RS.jpg/220px-The_fireplace-RS.jpg" data-file-width="2048" data-file-height="1536" data-file-type="bitmap" height="165" width="220" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/9/94/The_fireplace-RS.jpg/330px-The_fireplace-RS.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/9/94/The_fireplace-RS.jpg/440px-The_fireplace-RS.jpg 2x" id="mwvA"></a><figcaption id="mwvQ"><a rel="mw:WikiLink" href="./en" title="en" id="mwvg">en</a> <a rel="mw:WikiLink" href="./öppen" title="öppen" id="mwvw">öppen</a> <a rel="mw:WikiLink" href="./spis" title="spis" id="mwwA">spis</a> (1.1)</figcaption></figure>
  </section>
</div>
    HTML

    assert_equal 0, actual.images.size
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

  test 'it does not pick up style tags' do
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
        <th class="forma" style="font-weight: normal;"><a rel="mw:WikiLink" href="./przypadek#pl" title="przypadek">przypadek</a></th>
        <th style="font-weight: normal;"><a rel="mw:WikiLink" href="./liczba_pojedyncza#pl" title="liczba pojedyncza">liczba pojedyncza</a></th>
        <th style="font-weight: normal;"><a rel="mw:WikiLink" href="./liczba_mnoga#pl" title="liczba mnoga">liczba mnoga</a></th>
      </tr>
      <tr class="forma">
        <td class="forma"><span id="linkLanguage" title="polski"></span><a rel="mw:WikiLink" href="./mianownik" title="mianownik">mianownik</a><span id="linkLanguage" title=""></span></td>
        <td class="mianownik">cześć</td>
        <td class="mianownik">
          <style data-mw-deduplicate="TemplateStyles:r6240426" typeof="mw:Extension/templatestyles" about="#mwt32" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}'>
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
          <span class="potential-form" title="forma potencjalna lub rzadka">czci</span>
        </td>
      </tr>
      <tr class="forma">
        <td class="forma"><span id="linkLanguage" title="polski"></span><a rel="mw:WikiLink" href="./dopełniacz" title="dopełniacz">dopełniacz</a><span id="linkLanguage" title=""></span></td>
        <td>czci</td>
        <td>
          <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" about="#mwt33" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}' />
          <span class="potential-form" title="forma potencjalna lub rzadka">czci</span>
        </td>
      </tr>
      <tr class="forma">
        <td class="forma"><span id="linkLanguage" title="polski"></span><a rel="mw:WikiLink" href="./celownik" title="celownik">celownik</a><span id="linkLanguage" title=""></span></td>
        <td>czci</td>
        <td>
          <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" about="#mwt34" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}' />
          <span class="potential-form" title="forma potencjalna lub rzadka">czciom</span>
        </td>
      </tr>
      <tr class="forma">
        <td class="forma"><span id="linkLanguage" title="polski"></span><a rel="mw:WikiLink" href="./biernik" title="biernik">biernik</a><span id="linkLanguage" title=""></span></td>
        <td>cześć</td>
        <td>
          <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" about="#mwt35" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}' />
          <span class="potential-form" title="forma potencjalna lub rzadka">czci</span>
        </td>
      </tr>
      <tr class="forma">
        <td class="forma"><span id="linkLanguage" title="polski"></span><a rel="mw:WikiLink" href="./narzędnik" title="narzędnik">narzędnik</a><span id="linkLanguage" title=""></span></td>
        <td>czcią</td>
        <td>
          <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" about="#mwt36" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}' />
          <span class="potential-form" title="forma potencjalna lub rzadka">czciami</span>
        </td>
      </tr>
      <tr class="forma">
        <td class="forma"><span id="linkLanguage" title="polski"></span><a rel="mw:WikiLink" href="./miejscownik" title="miejscownik">miejscownik</a><span id="linkLanguage" title=""></span></td>
        <td>czci</td>
        <td>
          <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" about="#mwt37" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}' />
          <span class="potential-form" title="forma potencjalna lub rzadka">czciach</span>
        </td>
      </tr>
      <tr class="forma">
        <td class="forma"><span id="linkLanguage" title="polski"></span><a rel="mw:WikiLink" href="./wołacz" title="wołacz">wołacz</a><span id="linkLanguage" title=""></span></td>
        <td>czci</td>
        <td>
          <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" about="#mwt38" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}' />
          <span class="potential-form" title="forma potencjalna lub rzadka">czci</span>
        </td>
      </tr>
    </tbody>
  </table>
</div>
    HTML

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


  test 'it parses the conjugation for verb niedokonany' do
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
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język polski</span>
    </div>
  </div>
  <table class="wikitable odmiana" style="text-align: center; border: none;">
    <tbody>
      <tr>
        <th rowspan="2" colspan="2"><a rel="mw:WikiLink" href="./forma" title="forma">forma</a></th>
        <th colspan="3"><a rel="mw:WikiLink" href="./liczba_pojedyncza" title="liczba pojedyncza">liczba pojedyncza</a></th>
        <th colspan="3"><a rel="mw:WikiLink" href="./liczba_mnoga" title="liczba mnoga">liczba mnoga</a></th>
      </tr>
      <tr>
        <th width="14%">
          <i>1.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt64" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
          <span class="short-container">
            <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#O" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
              <span class="short-wrapper" title="osoba" data-expanded="osoba"><span class="short-content">os.</span></span>
            </a>
          </span>
        </th>
        <th width="14%">
          <i>2.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt65" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
          <span class="short-container">
            <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#O" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
              <span class="short-wrapper" title="osoba" data-expanded="osoba"><span class="short-content">os.</span></span>
            </a>
          </span>
        </th>
        <th width="14%">
          <i>3.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt66" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
          <span class="short-container">
            <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#O" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
              <span class="short-wrapper" title="osoba" data-expanded="osoba"><span class="short-content">os.</span></span>
            </a>
          </span>
        </th>
        <th width="14%">
          <i>1.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt67" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
          <span class="short-container">
            <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#O" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
              <span class="short-wrapper" title="osoba" data-expanded="osoba"><span class="short-content">os.</span></span>
            </a>
          </span>
        </th>
        <th width="14%">
          <i>2.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt68" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
          <span class="short-container">
            <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#O" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
              <span class="short-wrapper" title="osoba" data-expanded="osoba"><span class="short-content">os.</span></span>
            </a>
          </span>
        </th>
        <th width="14%">
          <i>3.</i> <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt69" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
          <span class="short-container">
            <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#O" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
              <span class="short-wrapper" title="osoba" data-expanded="osoba"><span class="short-content">os.</span></span>
            </a>
          </span>
        </th>
      </tr>
      <tr>
        <th colspan="2"><a rel="mw:WikiLink" href="./bezokolicznik" title="bezokolicznik">bezokolicznik</a></th>
        <td colspan="13"><b>zrobić </b></td>
      </tr>
      <tr>
        <th colspan="2"><a rel="mw:WikiLink" href="./czas_przyszły_prosty" title="czas przyszły prosty">czas przyszły prosty</a></th>
        <td>zrobię</td>
        <td>zrobisz</td>
        <td>zrobi</td>
        <td>zrobimy</td>
        <td>zrobicie</td>
        <td>zrobią</td>
      </tr>
      <tr>
        <th rowspan="3"><a rel="mw:WikiLink" href="./czas_przeszły" title="czas przeszły">czas przeszły</a></th>
        <th><i>m</i></th>
        <td>zrobiłem</td>
        <td>zrobiłeś</td>
        <td>zrobił</td>
        <td>zrobiliśmy</td>
        <td>zrobiliście</td>
        <td>zrobili</td>
      </tr>
      <tr>
        <th><i>ż</i></th>
        <td>zrobiłam</td>
        <td>zrobiłaś</td>
        <td>zrobiła</td>
        <td rowspan="2">zrobiłyśmy</td>
        <td rowspan="2">zrobiłyście</td>
        <td rowspan="2">zrobiły</td>
      </tr>
      <tr>
        <th><i>n</i></th>
        <td>
          <style data-mw-deduplicate="TemplateStyles:r6240426" typeof="mw:Extension/templatestyles" about="#mwt70" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}'>
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
          <span class="potential-form" title="forma potencjalna lub rzadka">zrobiłom </span>
        </td>
        <td>
          <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" about="#mwt71" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}' />
          <span class="potential-form" title="forma potencjalna lub rzadka">zrobiłoś </span>
        </td>
        <td>zrobiło</td>
      </tr>
      <tr>
        <th colspan="2"><a rel="mw:WikiLink" href="./tryb_rozkazujący" title="tryb rozkazujący">tryb rozkazujący</a></th>
        <td><a rel="mw:WikiLink" href="./niech" title="niech">niech</a> zrobię</td>
        <td>zrób</td>
        <td><a rel="mw:WikiLink" href="./niech" title="niech">niech</a> zrobi</td>
        <td>zróbmy</td>
        <td>zróbcie</td>
        <td><a rel="mw:WikiLink" href="./niech" title="niech">niech</a> zrobią</td>
      </tr>
      <tr>
        <td colspan="8" style="padding: 0; border: none;">
          <table class="wikitable odmiana collapsible collapsed" style="width: 100%; margin: 5px 0 0 0;">
            <tbody>
              <tr>
                <th colspan="8" style="font-weight: normal;"><span typeof="mw:Entity">&nbsp;</span>pozostałe formy</th>
              </tr>
              <tr>
                <th rowspan="3"><a rel="mw:WikiLink" href="./czas_zaprzeszły" title="czas zaprzeszły">czas zaprzeszły</a></th>
                <th><i>m</i></th>
                <td>zrobiłem <a rel="mw:WikiLink" href="./być" title="być">był</a></td>
                <td>zrobiłeś <a rel="mw:WikiLink" href="./być" title="być">był</a></td>
                <td>zrobił <a rel="mw:WikiLink" href="./być" title="być">był</a></td>
                <td>zrobiliśmy <a rel="mw:WikiLink" href="./być" title="być">byli</a></td>
                <td>zrobiliście <a rel="mw:WikiLink" href="./być" title="być">byli</a></td>
                <td>zrobili <a rel="mw:WikiLink" href="./być" title="być">byli</a></td>
              </tr>
              <tr>
                <th><i>ż</i></th>
                <td>zrobiłam <a rel="mw:WikiLink" href="./być" title="być">była</a></td>
                <td>zrobiłaś <a rel="mw:WikiLink" href="./być" title="być">była</a></td>
                <td>zrobiła <a rel="mw:WikiLink" href="./być" title="być">była</a></td>
                <td rowspan="2">zrobiłyśmy <a rel="mw:WikiLink" href="./być" title="być">były</a></td>
                <td rowspan="2">zrobiłyście <a rel="mw:WikiLink" href="./być" title="być">były</a></td>
                <td rowspan="2">zrobiły <a rel="mw:WikiLink" href="./być" title="być">były</a></td>
              </tr>
              <tr>
                <th><i>n</i></th>
                <td>
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" about="#mwt72" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}' />
                  <span class="potential-form" title="forma potencjalna lub rzadka">zrobiłom <a rel="mw:WikiLink" href="./być" title="być">było</a></span>
                </td>
                <td>
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" about="#mwt73" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}' />
                  <span class="potential-form" title="forma potencjalna lub rzadka">zrobiłoś <a rel="mw:WikiLink" href="./być" title="być">było</a></span>
                </td>
                <td>zrobiło <a rel="mw:WikiLink" href="./być" title="być">było</a></td>
              </tr>
              <tr>
                <th colspan="2"><a rel="mw:WikiLink" href="./forma_bezosobowa" title="forma bezosobowa">forma bezosobowa</a> <a rel="mw:WikiLink" href="./czas_przeszły" title="czas przeszły">czasu przeszłego</a></th>
                <td colspan="6">zrobiono</td>
              </tr>
              <tr>
                <th rowspan="3"><a rel="mw:WikiLink" href="./tryb_przypuszczający" title="tryb przypuszczający">tryb przypuszczający</a></th>
                <th><i>m</i></th>
                <td width="14%">
                  zrobiłbym,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">byłbym</a> zrobił
                </td>
                <td width="14%">
                  zrobiłbyś,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">byłbyś</a> zrobił
                </td>
                <td width="14%">
                  zrobiłby,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">byłby</a> zrobił
                </td>
                <td width="14%">
                  zrobilibyśmy,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">bylibyśmy</a> zrobili
                </td>
                <td width="14%">
                  zrobilibyście,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">bylibyście</a> zrobili
                </td>
                <td width="14%">
                  zrobiliby,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">byliby</a> zrobili
                </td>
              </tr>
              <tr>
                <th><i>ż</i></th>
                <td>
                  zrobiłabym,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">byłabym</a> zrobiła
                </td>
                <td>
                  zrobiłabyś,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">byłabyś</a> zrobiła
                </td>
                <td>
                  zrobiłaby,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">byłaby</a> zrobiła
                </td>
                <td rowspan="2">
                  zrobiłybyśmy,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">byłybyśmy</a> zrobiły
                </td>
                <td rowspan="2">
                  zrobiłybyście,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">byłybyście</a> zrobiły
                </td>
                <td rowspan="2">
                  zrobiłyby,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">byłyby</a> zrobiły
                </td>
              </tr>
              <tr>
                <th><i>n</i></th>
                <td>
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" about="#mwt74" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}' />
                  <span class="potential-form" title="forma potencjalna lub rzadka">
                    zrobiłobym,<br />
                    <a rel="mw:WikiLink" href="./być" title="być">byłobym</a> zrobiło
                  </span>
                </td>
                <td>
                  <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240426" about="#mwt75" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"potencjalnie/styles.css"}}' />
                  <span class="potential-form" title="forma potencjalna lub rzadka">
                    zrobiłobyś,<br />
                    <a rel="mw:WikiLink" href="./być" title="być">byłobyś</a> zrobiło
                  </span>
                </td>
                <td>
                  zrobiłoby,<br />
                  <a rel="mw:WikiLink" href="./być" title="być">byłoby</a> zrobiło
                </td>
              </tr>
              <tr>
                <th rowspan="3"><a rel="mw:WikiLink" href="./imiesłów_przymiotnikowy_przeszły" title="imiesłów przymiotnikowy przeszły">imiesłów przymiotnikowy przeszły</a></th>
                <th><i>m</i></th>
                <td colspan="3">zrobiony</td>
                <td colspan="3">zrobieni</td>
              </tr>
              <tr>
                <th><i>ż</i></th>
                <td colspan="3">zrobiona</td>
                <td rowspan="2" colspan="3">zrobione</td>
              </tr>
              <tr>
                <th><i>n</i></th>
                <td colspan="3">zrobione</td>
              </tr>
              <tr>
                <th colspan="2"><a rel="mw:WikiLink" href="./imiesłów_przysłówkowy_uprzedni" title="imiesłów przysłówkowy uprzedni">imiesłów przysłówkowy uprzedni</a></th>
                <td colspan="6">zrobiwszy</td>
              </tr>
              <tr>
                <th colspan="2"><a rel="mw:WikiLink" href="./rzeczownik_odczasownikowy" title="rzeczownik odczasownikowy">rzeczownik odczasownikowy</a></th>
                <td colspan="6"><a rel="mw:WikiLink" href="./zrobienie" title="zrobienie">zrobienie</a>, <a rel="mw:WikiLink" href="./niezrobienie" title="niezrobienie">niezrobienie</a></td>
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

  test 'it parses categories' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język polski</span>
    </div>
  </div>
  <section data-mw-section-id="1" id="mwAg">
    <dl about="#mwt12">
      <dt>
        <span class="field field-title fld-znaczenia field-pl" data-field="znaczenia" data-section-links="pl">znaczenia<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <p id="mwJA">
      <i id="mwJQ">czasownik przechodni niedokonany</i> (
      <style data-mw-deduplicate="TemplateStyles:r6240524" typeof="mw:Extension/templatestyles mw:Transclusion" about="#mwt13" data-mw='{"parts":[{"template":{"target":{"wt":"dk","href":"./Szablon:dk"},"params":{},"i":0}}]}' id="mwJg">
        .mw-parser-output .short-container {
          font-style: italic;
          text-decoration: none;
        }
        .mw-parser-output .short-no-style {
          font-style: normal;
        }
        .mw-parser-output .short-container a:hover {
          color: #002bb8;
          text-decoration: underline;
        }
        .mw-parser-output .short-container a,
        .mw-parser-output .short-container a:visited {
          color: black;
        }
        .mw-parser-output .short-variant1 a,
        .mw-parser-output .short-variant1 a:visited {
          color: #002bb8;
        }
        .mw-parser-output .short-variant2 a,
        .mw-parser-output .short-variant2 a:visited {
          color: red;
        }
        .mw-parser-output .short-variant3 a,
        .mw-parser-output .short-variant3 a:visited {
          color: green;
        }
      </style>
      <span class="short-container" about="#mwt13" id="mwJw">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#D" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="aspekt dokonany" data-expanded="aspekt dokonany"><span class="short-content">dk.</span></span>
        </a>
      </span>
      <a rel="mw:WikiLink" href="./pomalować" title="pomalować" id="mwKA">pomalować</a>)
    </p>
    <dl id="mwKQ">
      <dd id="mwKg">
        (1.1)
        <link
          rel="mw-deduplicated-inline-style"
          href="mw-data:TemplateStyles:r6240524"
          about="#mwt16"
          typeof="mw:Extension/templatestyles mw:Transclusion"
          data-mw='{"parts":[{"template":{"target":{"wt":"techn","href":"./Szablon:techn"},"params":{},"i":0}}]}'
          id="mwKw"
        />
        <span class="short-container" about="#mwt16" id="mwLA">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#T" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="technologia, technika, techniczny" data-expanded="technologia, technika, techniczny"><span class="short-content">techn.</span></span>
          </a>
        </span>
        <a rel="mw:WikiLink" href="./nakładać" title="nakładać" id="mwLQ">nakładać</a> <a rel="mw:WikiLink" href="./farba" title="farba" id="mwLg">farbę</a> <a rel="mw:WikiLink" href="./na" title="na" id="mwLw">na</a>
        <a rel="mw:WikiLink" href="./jakiś" title="jakiś" id="mwMA">jakąś</a> <a rel="mw:WikiLink" href="./powierzchnia" title="powierzchnia" id="mwMQ">powierzchnię</a> (
        <a rel="mw:WikiLink" href="./płótno" title="płótno" id="mwMg">płótno</a>, <a rel="mw:WikiLink" href="./papier" title="papier" id="mwMw">papier</a>, <a rel="mw:WikiLink" href="./tektura" title="tektura" id="mwNA">tekturę</a>,
        <a rel="mw:WikiLink" href="./ściana" title="ściana" id="mwNQ">ścianę</a>), <a rel="mw:WikiLink" href="./wypełniać" title="wypełniać" id="mwNg">wypełniać</a> <a rel="mw:WikiLink" href="./coś" title="coś" id="mwNw">coś</a>
        <a rel="mw:WikiLink" href="./kolor" title="kolor" id="mwOA">kolorem</a>
      </dd>
      <dd id="mwOQ">
        (1.2)
        <link
          rel="mw-deduplicated-inline-style"
          href="mw-data:TemplateStyles:r6240524"
          about="#mwt19"
          typeof="mw:Extension/templatestyles mw:Transclusion"
          data-mw='{"parts":[{"template":{"target":{"wt":"fryzj","href":"./Szablon:fryzj"},"params":{},"i":0}}]}'
          id="mwOg"
        />
        <span class="short-container" about="#mwt19" id="mwOw">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#F" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="fryzjerstwo, fryzjerski" data-expanded="fryzjerstwo, fryzjerski"><span class="short-content">fryzj.</span></span>
          </a>
        </span>
        <a rel="mw:WikiLink" href="./nakładać" title="nakładać" id="mwPA">nakładać</a> <a rel="mw:WikiLink" href="./farba" title="farba" id="mwPQ">farbę</a> <a rel="mw:WikiLink" href="./na" title="na" id="mwPg">na</a>
        <a rel="mw:WikiLink" href="./włos" title="włos" id="mwPw">włosy</a>
      </dd>
    </dl>
    <p id="mwQA">
      <i id="mwQQ">czasownik przechodni niedokonany</i> (
      <link
        rel="mw-deduplicated-inline-style"
        href="mw-data:TemplateStyles:r6240524"
        about="#mwt22"
        typeof="mw:Extension/templatestyles mw:Transclusion"
        data-mw='{"parts":[{"template":{"target":{"wt":"dk","href":"./Szablon:dk"},"params":{},"i":0}}]}'
        id="mwQg"
      />
      <span class="short-container" about="#mwt22" id="mwQw">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#D" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="aspekt dokonany" data-expanded="aspekt dokonany"><span class="short-content">dk.</span></span>
        </a>
      </span>
      <a rel="mw:WikiLink" href="./namalować" title="namalować" id="mwRA">namalować</a>)
    </p>
    <dl id="mwRQ">
      <dd id="mwRg">
        (2.1)
        <link
          rel="mw-deduplicated-inline-style"
          href="mw-data:TemplateStyles:r6240524"
          about="#mwt25"
          typeof="mw:Extension/templatestyles mw:Transclusion"
          data-mw='{"parts":[{"template":{"target":{"wt":"szt","href":"./Szablon:szt"},"params":{},"i":0}}]}'
          id="mwRw"
        />
        <span class="short-container" about="#mwt25" id="mwSA">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#S" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="sztuka" data-expanded="sztuka"><span class="short-content">szt.</span></span>
          </a>
        </span>
        <a rel="mw:WikiLink" href="./tworzyć" title="tworzyć" id="mwSQ">tworzyć</a> <a rel="mw:WikiLink" href="./obraz" title="obraz" id="mwSg">obraz</a> <a rel="mw:WikiLink" href="./lub" title="lub" id="mwSw">lub</a>
        <a rel="mw:WikiLink" href="./dzieło" title="dzieło" id="mwTA">dzieło</a> <a rel="mw:WikiLink" href="./malarski" title="malarski" id="mwTQ">malarskie</a>
      </dd>
      <dd id="mwTg">
        (2.2)
        <link
          rel="mw-deduplicated-inline-style"
          href="mw-data:TemplateStyles:r6240524"
          about="#mwt28"
          typeof="mw:Extension/templatestyles mw:Transclusion"
          data-mw='{"parts":[{"template":{"target":{"wt":"przen","href":"./Szablon:przen"},"params":{},"i":0}}]}'
          id="mwTw"
        />
        <span class="short-container" about="#mwt28" id="mwUA">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#P" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="przenośnie, przenośnia" data-expanded="przenośnie, przenośnia"><span class="short-content">przen.</span></span>
          </a>
        </span>
        <link
          rel="mw-deduplicated-inline-style"
          href="mw-data:TemplateStyles:r6240524"
          about="#mwt31"
          typeof="mw:Extension/templatestyles mw:Transclusion"
          data-mw='{"parts":[{"template":{"target":{"wt":"książk","href":"./Szablon:książk"},"params":{},"i":0}}]}'
          id="mwUQ"
        />
        <span class="short-container" about="#mwt31" id="mwUg">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#K" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="książkowy&nbsp;– książkowy styl" data-expanded="książkowy"><span class="short-content">książk.</span></span>
          </a>
        </span>
        <a rel="mw:WikiLink" href="./ukazywać" title="ukazywać" id="mwUw">ukazywać</a> <a rel="mw:WikiLink" href="./coś" title="coś" id="mwVA">coś</a>
      </dd>
    </dl>
    <p id="mwVQ">
      <i id="mwVg">czasownik przechodni niedokonany</i> (
      <link
        rel="mw-deduplicated-inline-style"
        href="mw-data:TemplateStyles:r6240524"
        about="#mwt34"
        typeof="mw:Extension/templatestyles mw:Transclusion"
        data-mw='{"parts":[{"template":{"target":{"wt":"dk","href":"./Szablon:dk"},"params":{},"i":0}}]}'
        id="mwVw"
      />
      <span class="short-container" about="#mwt34" id="mwWA">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#D" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="aspekt dokonany" data-expanded="aspekt dokonany"><span class="short-content">dk.</span></span>
        </a>
      </span>
      <a rel="mw:WikiLink" href="./umalować" title="umalować" id="mwWQ">umalować</a>)
    </p>
    <dl id="mwWg">
      <dd id="mwWw">
        (3.1)
        <link
          rel="mw-deduplicated-inline-style"
          href="mw-data:TemplateStyles:r6240524"
          about="#mwt37"
          typeof="mw:Extension/templatestyles mw:Transclusion"
          data-mw='{"parts":[{"template":{"target":{"wt":"kosmet","href":"./Szablon:kosmet"},"params":{},"i":0}}]}'
          id="mwXA"
        />
        <span class="short-container" about="#mwt37" id="mwXQ">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#K" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="kosmetyka, kosmetyczny, kosmetologia" data-expanded="kosmetyka, kosmetyczny, kosmetologia"><span class="short-content">kosmet.</span></span>
          </a>
        </span>
        <a rel="mw:WikiLink" href="./nakładać" title="nakładać" id="mwXg">nakładać</a> <a rel="mw:WikiLink" href="./kolorowy" title="kolorowy" id="mwXw">kolorowe</a>
        <a rel="mw:WikiLink" href="./kosmetyk" title="kosmetyk" id="mwYA">kosmetyki</a> <a rel="mw:WikiLink" href="./na" title="na" id="mwYQ">na</a> <a rel="mw:WikiLink" href="./twarz" title="twarz" id="mwYg">twarz</a> (
        <a rel="mw:WikiLink" href="./np." title="np." id="mwYw">np.</a>: <a rel="mw:WikiLink" href="./szminka" title="szminka" id="mwZA">szminkę</a> <a rel="mw:WikiLink" href="./na" title="na" id="mwZQ">na</a>
        <a rel="mw:WikiLink" href="./usta" title="usta" id="mwZg">usta</a>, <a rel="mw:WikiLink" href="./tusz" title="tusz" id="mwZw">tusz</a> <a rel="mw:WikiLink" href="./na" title="na" id="mwaA">na</a>
        <a rel="mw:WikiLink" href="./rzęsa" title="rzęsa" id="mwaQ">rzęsy</a>, <a rel="mw:WikiLink" href="./cień" title="cień" id="mwag">cienie</a> <a rel="mw:WikiLink" href="./na" title="na" id="mwaw">na</a>
        <a rel="mw:WikiLink" href="./powieka" title="powieka" id="mwbA">powieki</a>, <a rel="mw:WikiLink" href="./róż" title="róż" id="mwbQ">róż</a> <a rel="mw:WikiLink" href="./na" title="na" id="mwbg">na</a>
        <a rel="mw:WikiLink" href="./policzek" title="policzek" id="mwbw">policzki</a> <a rel="mw:WikiLink" href="./itp." title="itp." id="mwcA">itp.</a>)
      </dd>
    </dl>
    <p id="mwcQ">
      <i id="mwcg">czasownik zwrotny niedokonany <b id="mwcw">malować się</b></i> (
      <link
        rel="mw-deduplicated-inline-style"
        href="mw-data:TemplateStyles:r6240524"
        about="#mwt40"
        typeof="mw:Extension/templatestyles mw:Transclusion"
        data-mw='{"parts":[{"template":{"target":{"wt":"dk","href":"./Szablon:dk"},"params":{},"i":0}}]}'
        id="mwdA"
      />
      <span class="short-container" about="#mwt40" id="mwdQ">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#D" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="aspekt dokonany" data-expanded="aspekt dokonany"><span class="short-content">dk.</span></span>
        </a>
      </span>
      <a rel="mw:WikiLink" href="./umalować_się" title="umalować się" class="mw-redirect" id="mwdg">umalować się</a>)
    </p>
    <dl id="mwdw">
      <dd id="mweA">
        (4.1)
        <link
          rel="mw-deduplicated-inline-style"
          href="mw-data:TemplateStyles:r6240524"
          about="#mwt43"
          typeof="mw:Extension/templatestyles mw:Transclusion"
          data-mw='{"parts":[{"template":{"target":{"wt":"kosmet","href":"./Szablon:kosmet"},"params":{},"i":0}}]}'
          id="mweQ"
        />
        <span class="short-container" about="#mwt43" id="mweg">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#K" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="kosmetyka, kosmetyczny, kosmetologia" data-expanded="kosmetyka, kosmetyczny, kosmetologia"><span class="short-content">kosmet.</span></span>
          </a>
        </span>
        <a rel="mw:WikiLink" href="./robić" title="robić" id="mwew">robić</a> <a rel="mw:WikiLink" href="./sobie" title="sobie" id="mwfA">sobie</a> <a rel="mw:WikiLink" href="./makijaż" title="makijaż" id="mwfQ">makijaż</a>
      </dd>
    </dl>
    <p id="mwfg">
      <i id="mwfw">czasownik zwrotny niedokonany <b id="mwgA">malować się</b></i> (
      <link
        rel="mw-deduplicated-inline-style"
        href="mw-data:TemplateStyles:r6240524"
        about="#mwt46"
        typeof="mw:Extension/templatestyles mw:Transclusion"
        data-mw='{"parts":[{"template":{"target":{"wt":"dk","href":"./Szablon:dk"},"params":{},"i":0}}]}'
        id="mwgQ"
      />
      <span class="short-container" about="#mwt46" id="mwgg">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#D" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="aspekt dokonany" data-expanded="aspekt dokonany"><span class="short-content">dk.</span></span>
        </a>
      </span>
      <i id="mwgw">brak</i>)
    </p>
    <dl id="mwhA">
      <dd id="mwhQ">
        (5.1) <i id="mwhg">(o uczuciu, stanie ducha)</i> <a rel="mw:WikiLink" href="./ukazywać_się" title="ukazywać się" class="mw-redirect" id="mwhw">ukazywać się</a>,
        <a rel="mw:WikiLink" href="./uwidaczniać_się" title="uwidaczniać się" class="new" id="mwiA">uwidaczniać się</a> <a rel="mw:WikiLink" href="./na" title="na" id="mwiQ">na</a>
        <a rel="mw:WikiLink" href="./twarz" title="twarz" id="mwig">twarzy</a> <a rel="mw:WikiLink" href="./lub" title="lub" id="mwiw">lub</a> <a rel="mw:WikiLink" href="./w" title="w" id="mwjA">w</a>
        <a rel="mw:WikiLink" href="./postawa" title="postawa" id="mwjQ">postawie</a> <a rel="mw:WikiLink" href="./człowiek" title="człowiek" id="mwjg">człowieka</a>
      </dd>
    </dl>
  </section>
</div>
    HTML

    assert_equal 5, actual.categories.size
    assert_includes actual.categories, 'czasownik przechodni niedokonany dk. pomalować'
    assert_includes actual.categories, 'czasownik przechodni niedokonany dk. namalować'
    assert_includes actual.categories, 'czasownik przechodni niedokonany dk. umalować'
    assert_includes actual.categories, 'czasownik zwrotny niedokonany malować się dk. umalować się'
    assert_includes actual.categories, 'czasownik zwrotny niedokonany malować się dk. brak'
  end

  test 'it parses translations from Swedish' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język szwedzki</span>
    </div>
  </div>
  <section data-mw-section-id="1" id="mwAg">
    <dl about="#mwt7">
      <dt>
        <span class="field field-title fld-znaczenia field-pl" data-field="znaczenia" data-section-links="pl">znaczenia<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <p id="mwBg"><i id="mwBw">wykrzyknik</i></p>
    <dl id="mwCA">
      <dd id="mwCQ">
        (1.1) <a rel="mw:WikiLink" href="./na_zdrowie" title="na zdrowie" id="mwCg">na zdrowie</a> <i id="mwCw">(przed wzniesieniem toastu)</i>
        <sup about="#mwt10" class="mw-ref reference" id="cite_ref-u_1-0" rel="dc:references" typeof="mw:Extension/ref" data-mw='{"name":"ref","attrs":{"name":"u"},"body":{"id":"mw-reference-text-cite_note-u-1"}}'>
          <a href="./skål#cite_note-u-1" style="counter-reset: mw-Ref 1;" id="mwDA"><span class="mw-reflink-text" id="mwDQ">[1]</span></a>
        </sup>
      </dd>
    </dl>
    <p id="mwDg"><i id="mwDw">rzeczownik, rodzaj wspólny</i></p>
    <dl id="mwEA">
      <dd id="mwEQ">
        (2.1) <a rel="mw:WikiLink" href="./miska" title="miska" id="mwEg">miska</a>
        <sup about="#mwt12" class="mw-ref reference" id="cite_ref-u_1-1" rel="dc:references" typeof="mw:Extension/ref" data-mw='{"name":"ref","attrs":{"name":"u"}}'>
          <a href="./skål#cite_note-u-1" style="counter-reset: mw-Ref 1;" id="mwEw"><span class="mw-reflink-text" id="mwFA">[1]</span></a>
        </sup>
      </dd>
      <dd id="mwFQ">
        (2.2) <a rel="mw:WikiLink" href="./toast" title="toast" id="mwFg">toast</a>
        <sup about="#mwt14" class="mw-ref reference" id="cite_ref-u_1-2" rel="dc:references" typeof="mw:Extension/ref" data-mw='{"name":"ref","attrs":{"name":"u"}}'>
          <a href="./skål#cite_note-u-1" style="counter-reset: mw-Ref 1;" id="mwFw"><span class="mw-reflink-text" id="mwGA">[1]</span></a>
        </sup>
      </dd>
    </dl>
  </section>
</div>
    HTML

    assert_equal ['język szwedzki'], actual.other_translations.keys
    assert_includes actual.other_translations['język szwedzki'], 'na zdrowie (przed wzniesieniem toastu)'
    assert_includes actual.other_translations['język szwedzki'], 'miska'
    assert_includes actual.other_translations['język szwedzki'], 'toast'
  end

  test 'it parses translations from other languages' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <section data-mw-section-id="1" id="mwAw">
    <h2 id="haus_(język_indonezyjski)">
      <span id="haus_.28j.C4.99zyk_indonezyjski.29" typeof="mw:FallbackId"></span>haus (
      <span class="lang-code primary-lang-code lang-code-id" id="id" about="#mwt2" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"język indonezyjski","href":"./Szablon:język_indonezyjski"},"params":{},"i":0}}]}'>
        <a rel="mw:WikiLink" href="./Kategoria:Język_indonezyjski" title="Kategoria:Język indonezyjski">język indonezyjski</a>
      </span>
      <link rel="mw:PageProp/Category" href="./Kategoria:indonezyjski_(indeks)" about="#mwt2" /><link rel="mw:PageProp/Category" href="./Kategoria:indonezyjski_(indeks_a_tergo)#suah" about="#mwt2" />
      <link rel="mw:PageProp/Category" href="./Kategoria:Język_indonezyjski_-_przymiotniki" about="#mwt2" id="mwBA" />)
    </h2>
    <span about="#mwt3" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"wymowa","href":"./Szablon:wymowa"},"params":{},"i":0}}]}' id="mwBQ"> </span>
    <dl about="#mwt3">
      <dt>
        <span class="field field-title fld-wymowa field-keep" data-field="wymowa" data-section-links="keep">wymowa<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt4" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"znaczenia","href":"./Szablon:znaczenia"},"params":{},"i":0}}]}' id="mwBg"> </span>
    <dl about="#mwt4">
      <dt>
        <span class="field field-title fld-znaczenia field-pl" data-field="znaczenia" data-section-links="pl">znaczenia<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <p id="mwBw"><i id="mwCA">przymiotnik</i></p>
    <dl id="mwCQ">
      <dd id="mwCg">(1.1) <a rel="mw:WikiLink" href="./spragniony" title="spragniony" id="mwCw">spragniony</a></dd>
    </dl>
    <span about="#mwt5" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"odmiana","function":"grammar"},"params":{},"i":0}}]}' id="mwDA"> </span>
    <dl about="#mwt5">
      <dt>
        <span class="field field-title fld-odmiana field-foreign" data-field="odmiana" data-section-links="foreign">
          <a rel="mw:WikiLink" href="./Wikisłownik:Zasady_tworzenia_haseł/Odmiana" title="Wikisłownik:Zasady tworzenia haseł/Odmiana">odmiana</a><span typeof="mw:Entity">:</span>
        </span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt6" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"przykłady","href":"./Szablon:przykłady"},"params":{},"i":0}}]}' id="mwDQ"> </span>
    <dl about="#mwt6">
      <dt>
        <span class="field field-title fld-przyklady field-exampl" data-field="przyklady" data-section-links="exampl" style="display: block; clear: left;">przykłady<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt7" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"składnia","href":"./Szablon:składnia"},"params":{},"i":0}}]}' id="mwDg"> </span>
    <dl about="#mwt7">
      <dt>
        <span class="field field-title fld-skladnia field-foreign" data-field="skladnia" data-section-links="foreign">składnia<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt8" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"kolokacje","href":"./Szablon:kolokacje"},"params":{},"i":0}}]}' id="mwDw"> </span>
    <dl about="#mwt8">
      <dt>
        <span class="field field-title fld-kolokacje field-foreign" data-field="kolokacje" data-section-links="foreign">
          <a rel="mw:WikiLink" href="./Wikisłownik:ZTH_kolokacje" title="Wikisłownik:ZTH kolokacje" class="mw-redirect">kolokacje</a><span typeof="mw:Entity">:</span>
        </span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt9" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"synonimy","href":"./Szablon:synonimy"},"params":{},"i":0}}]}' id="mwEA"> </span>
    <dl about="#mwt9">
      <dt>
        <span class="field field-title fld-synonimy field-foreign" data-field="synonimy" data-section-links="foreign">synonimy<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt10" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"antonimy","href":"./Szablon:antonimy"},"params":{},"i":0}}]}' id="mwEQ"> </span>
    <dl about="#mwt10">
      <dt>
        <span class="field field-title fld-antonimy field-foreign" data-field="antonimy" data-section-links="foreign">antonimy<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt11" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"hiperonimy","href":"./Szablon:hiperonimy"},"params":{},"i":0}}]}' id="mwEg"> </span>
    <dl about="#mwt11">
      <dt>
        <span class="field field-title fld-hiperonimy field-foreign" data-field="hiperonimy" data-section-links="foreign">hiperonimy<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt12" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"hiponimy","href":"./Szablon:hiponimy"},"params":{},"i":0}}]}' id="mwEw"> </span>
    <dl about="#mwt12">
      <dt>
        <span class="field field-title fld-hiponimy field-foreign" data-field="hiponimy" data-section-links="foreign">hiponimy<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt13" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"holonimy","href":"./Szablon:holonimy"},"params":{},"i":0}}]}' id="mwFA"> </span>
    <dl about="#mwt13">
      <dt>
        <span class="field field-title fld-holonimy field-foreign" data-field="holonimy" data-section-links="foreign">holonimy<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt14" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"meronimy","href":"./Szablon:meronimy"},"params":{},"i":0}}]}' id="mwFQ"> </span>
    <dl about="#mwt14">
      <dt>
        <span class="field field-title fld-meronimy field-foreign" data-field="meronimy" data-section-links="foreign">meronimy<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt15" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"pokrewne","href":"./Szablon:pokrewne"},"params":{},"i":0}}]}' id="mwFg"> </span>
    <dl about="#mwt15">
      <dt>
        <span class="field field-title fld-pokrewne field-foreign" data-field="pokrewne" data-section-links="foreign">wyrazy pokrewne<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt16" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"frazeologia","href":"./Szablon:frazeologia"},"params":{},"i":0}}]}' id="mwFw"> </span>
    <dl about="#mwt16">
      <dt>
        <span class="field field-title fld-frazeologia field-foreign" data-field="frazeologia" data-section-links="foreign">związki frazeologiczne<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt17" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"etymologia","href":"./Szablon:etymologia"},"params":{},"i":0}}]}' id="mwGA"> </span>
    <dl about="#mwt17">
      <dt>
        <span class="field field-title fld-etymologia field-keep" data-field="etymologia" data-section-links="keep">etymologia<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt18" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"uwagi","href":"./Szablon:uwagi"},"params":{},"i":0}}]}' id="mwGQ"> </span>
    <dl about="#mwt18">
      <dt>
        <span class="field field-title fld-uwagi field-keep" data-field="uwagi" data-section-links="keep">uwagi<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span
      about="#mwt19"
      typeof="mw:Transclusion"
      data-mw='{"parts":[{"template":{"target":{"wt":"źródła","href":"./Szablon:źródła"},"params":{},"i":0}},"\n: ",{"template":{"target":{"wt":"importEnWikt","href":"./Szablon:importEnWikt"},"params":{"1":{"wt":"indonezyjski"}},"i":1}}]}'
      id="mwGg"
    >
    </span>
    <dl about="#mwt19">
      <dt>
        <span class="field field-title fld-zrodla field-keep" data-field="zrodla" data-section-links="keep" style="display: block; clear: left;">źródła<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
      <dd>
        <link rel="mw:PageProp/Category" href="./Kategoria:import_z_angielskiego_Wikisłownika/indonezyjski" />
        <i>
          Hasło zaimportowane automatycznie – nie zostało zweryfikowane w papierowych słownikach lub wiarygodnych słownikach online. Jeśli znasz indonezyjski, kliknij na
          <span class="plainlinks"><a rel="mw:ExtLink" href="//pl.wiktionary.org/w/index.php?title=haus&amp;action=edit" class="external text">Edytuj</a></span>, dokonaj ewentualnych korekt i usuń niniejszy komunikat. Dziękujemy! Listę
          innych niesprawdzonych haseł w tym języku można znaleźć <a rel="mw:WikiLink" href="./Kategoria:import_z_angielskiego_Wikisłownika/indonezyjski" title="Kategoria:import z angielskiego Wikisłownika/indonezyjski">pod tym linkiem</a>.
        </i>
      </dd>
    </dl>
  </section>
  <section data-mw-section-id="3" id="mwRg">
    <h2 id="haus_(język_wilamowski)">
      <span id="haus_.28j.C4.99zyk_wilamowski.29" typeof="mw:FallbackId"></span>haus (
      <span class="lang-code primary-lang-code lang-code-wym" id="wym" about="#mwt50" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"język wilamowski","href":"./Szablon:język_wilamowski"},"params":{},"i":0}}]}'>
        <a rel="mw:WikiLink" href="./Kategoria:Język_wilamowski" title="Kategoria:Język wilamowski">język wilamowski</a>
      </span>
      <link rel="mw:PageProp/Category" href="./Kategoria:wilamowski_(indeks)" about="#mwt50" /><link rel="mw:PageProp/Category" href="./Kategoria:wilamowski_(indeks_a_tergo)#suah" about="#mwt50" />
      <link rel="mw:PageProp/Category" href="./Kategoria:Język_wilamowski_-_rzeczowniki" about="#mwt50" /><link rel="mw:PageProp/Category" href="./Kategoria:Język_wilamowski_-_rzeczowniki_rodzaju_nijakiego" about="#mwt50" id="mwRw" />)
    </h2>
    <span about="#mwt51" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"ortografie","href":"./Szablon:ortografie"},"params":{},"i":0}},"\n: [[haojs]] • [[hoüz]]"]}' id="mwSA"> </span>
    <dl about="#mwt51">
      <dt>
        <span class="field field-title fld-ortografie field-foreign" data-field="ortografie" data-section-links="foreign">zapisy w ortografiach alternatywnych<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
      <dd><a rel="mw:WikiLink" href="./haojs" title="haojs">haojs</a> • <a rel="mw:WikiLink" href="./hoüz" title="hoüz">hoüz</a></dd>
    </dl>
    <span about="#mwt52" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"wymowa","href":"./Szablon:wymowa"},"params":{},"i":0}}]}' id="mwSQ"> </span>
    <dl about="#mwt52">
      <dt>
        <span class="field field-title fld-wymowa field-keep" data-field="wymowa" data-section-links="keep">wymowa<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt53" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"znaczenia","href":"./Szablon:znaczenia"},"params":{},"i":0}}]}' id="mwSg"> </span>
    <dl about="#mwt53">
      <dt>
        <span class="field field-title fld-znaczenia field-pl" data-field="znaczenia" data-section-links="pl">znaczenia<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <p id="mwSw"><i id="mwTA">rzeczownik, rodzaj nijaki</i></p>
    <dl id="mwTQ">
      <dd id="mwTg">
        (1.1) <a rel="mw:WikiLink" href="./dom" title="dom" id="mwTw">dom</a>, <a rel="mw:WikiLink" href="./sień" title="sień" id="mwUA">sień</a>
        <sup about="#mwt58" class="mw-ref reference" id="cite_ref-2" rel="dc:references" typeof="mw:Extension/ref" data-mw='{"name":"ref","attrs":{},"body":{"id":"mw-reference-text-cite_note-2"}}'>
          <a href="./haus#cite_note-2" style="counter-reset: mw-Ref 1;" id="mwUQ"><span class="mw-reflink-text" id="mwUg">[1]</span></a>
        </sup>
        <sup about="#mwt61" class="mw-ref reference" id="cite_ref-3" rel="dc:references" typeof="mw:Extension/ref" data-mw='{"name":"ref","attrs":{},"body":{"id":"mw-reference-text-cite_note-3"}}'>
          <a href="./haus#cite_note-3" style="counter-reset: mw-Ref 2;" id="mwUw"><span class="mw-reflink-text" id="mwVA">[2]</span></a>
        </sup>
      </dd>
    </dl>
    <span
      about="#mwt62"
      typeof="mw:Transclusion"
      data-mw='{"parts":[{"template":{"target":{"wt":"odmiana","function":"grammar"},"params":{},"i":0}},"\n: (1.1) ",{"template":{"target":{"wt":"lp","href":"./Szablon:lp"},"params":{},"i":1}}," haus; ",{"template":{"target":{"wt":"lm","href":"./Szablon:lm"},"params":{},"i":2}}," houzyn (houzən)"]}'
      id="mwVQ"
    >
    </span>
    <dl about="#mwt62">
      <dt>
        <span class="field field-title fld-odmiana field-foreign" data-field="odmiana" data-section-links="foreign">
          <a rel="mw:WikiLink" href="./Wikisłownik:Zasady_tworzenia_haseł/Odmiana" title="Wikisłownik:Zasady tworzenia haseł/Odmiana">odmiana</a><span typeof="mw:Entity">:</span>
        </span>
      </dt>
      <dd></dd>
      <dd>
        (1.1) <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt66" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
        <span class="short-container short-variant1" about="#mwt67" typeof="mw:ExpandedAttrs" data-mw='{"attribs":[[{"txt":"class"},{"html":"short-container<span typeof=\"mw:Nowiki\" data-parsoid=\"{}\"></span> short-variant1"}]]}'>
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#L" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="liczba pojedyncza" data-expanded="liczba pojedyncza"><span class="short-content">lp</span></span>
          </a>
        </span>
        haus; <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt71" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
        <span class="short-container short-variant1" about="#mwt72" typeof="mw:ExpandedAttrs" data-mw='{"attribs":[[{"txt":"class"},{"html":"short-container<span typeof=\"mw:Nowiki\" data-parsoid=\"{}\"></span> short-variant1"}]]}'>
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#L" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="liczba mnoga" data-expanded="liczba mnoga"><span class="short-content">lm</span></span>
          </a>
        </span>
        houzyn (houzən)
      </dd>
    </dl>
    <span about="#mwt73" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"przykłady","href":"./Szablon:przykłady"},"params":{},"i":0}}]}' id="mwVg"> </span>
    <dl about="#mwt73">
      <dt>
        <span class="field field-title fld-przyklady field-exampl" data-field="przyklady" data-section-links="exampl" style="display: block; clear: left;">przykłady<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt74" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"składnia","href":"./Szablon:składnia"},"params":{},"i":0}}]}' id="mwVw"> </span>
    <dl about="#mwt74">
      <dt>
        <span class="field field-title fld-skladnia field-foreign" data-field="skladnia" data-section-links="foreign">składnia<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt75" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"kolokacje","href":"./Szablon:kolokacje"},"params":{},"i":0}}]}' id="mwWA"> </span>
    <dl about="#mwt75">
      <dt>
        <span class="field field-title fld-kolokacje field-foreign" data-field="kolokacje" data-section-links="foreign">
          <a rel="mw:WikiLink" href="./Wikisłownik:ZTH_kolokacje" title="Wikisłownik:ZTH kolokacje" class="mw-redirect">kolokacje</a><span typeof="mw:Entity">:</span>
        </span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt76" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"synonimy","href":"./Szablon:synonimy"},"params":{},"i":0}}]}' id="mwWQ"> </span>
    <dl about="#mwt76">
      <dt>
        <span class="field field-title fld-synonimy field-foreign" data-field="synonimy" data-section-links="foreign">synonimy<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt77" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"antonimy","href":"./Szablon:antonimy"},"params":{},"i":0}}]}' id="mwWg"> </span>
    <dl about="#mwt77">
      <dt>
        <span class="field field-title fld-antonimy field-foreign" data-field="antonimy" data-section-links="foreign">antonimy<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt78" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"hiperonimy","href":"./Szablon:hiperonimy"},"params":{},"i":0}}]}' id="mwWw"> </span>
    <dl about="#mwt78">
      <dt>
        <span class="field field-title fld-hiperonimy field-foreign" data-field="hiperonimy" data-section-links="foreign">hiperonimy<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt79" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"hiponimy","href":"./Szablon:hiponimy"},"params":{},"i":0}}]}' id="mwXA"> </span>
    <dl about="#mwt79">
      <dt>
        <span class="field field-title fld-hiponimy field-foreign" data-field="hiponimy" data-section-links="foreign">hiponimy<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt80" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"holonimy","href":"./Szablon:holonimy"},"params":{},"i":0}}]}' id="mwXQ"> </span>
    <dl about="#mwt80">
      <dt>
        <span class="field field-title fld-holonimy field-foreign" data-field="holonimy" data-section-links="foreign">holonimy<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt81" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"meronimy","href":"./Szablon:meronimy"},"params":{},"i":0}}]}' id="mwXg"> </span>
    <dl about="#mwt81">
      <dt>
        <span class="field field-title fld-meronimy field-foreign" data-field="meronimy" data-section-links="foreign">meronimy<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span
      about="#mwt82"
      typeof="mw:Transclusion"
      data-mw='{"parts":[{"template":{"target":{"wt":"pokrewne","href":"./Szablon:pokrewne"},"params":{},"i":0}},"\n: ",{"template":{"target":{"wt":"rzecz","href":"./Szablon:rzecz"},"params":{},"i":1}}," [[hausgənyss]] ",{"template":{"target":{"wt":"m","href":"./Szablon:m"},"params":{},"i":2}},", [[hausšłyssł̥]] ",{"template":{"target":{"wt":"m","href":"./Szablon:m"},"params":{},"i":3}},", [[hausśwełł]] ",{"template":{"target":{"wt":"m","href":"./Szablon:m"},"params":{},"i":4}}," / [[hausšłvełł]] ",{"template":{"target":{"wt":"m","href":"./Szablon:m"},"params":{},"i":5}},", [[haustjyr]] ",{"template":{"target":{"wt":"ż","href":"./Szablon:ż"},"params":{},"i":6}}]}'
      id="mwXw"
    >
    </span>
    <dl about="#mwt82">
      <dt>
        <span class="field field-title fld-pokrewne field-foreign" data-field="pokrewne" data-section-links="foreign">wyrazy pokrewne<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
      <dd>
        <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt85" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
        <span class="short-container">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#R" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="rzeczownik" data-expanded="rzeczownik"><span class="short-content">rzecz.</span></span>
          </a>
        </span>
        <a rel="mw:WikiLink" href="./hausgənyss" title="hausgənyss">hausgənyss</a>
        <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt88" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
        <span class="short-container">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#M" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="rodzaj męski" data-expanded="rodzaj męski"><span class="short-content">m</span></span>
          </a>
        </span>
        , <a rel="mw:WikiLink" href="./hausšłyssł̥" title="hausšłyssł̥">hausšłyssł̥</a>
        <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt91" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
        <span class="short-container">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#M" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="rodzaj męski" data-expanded="rodzaj męski"><span class="short-content">m</span></span>
          </a>
        </span>
        , <a rel="mw:WikiLink" href="./hausśwełł" title="hausśwełł">hausśwełł</a>
        <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt94" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
        <span class="short-container">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#M" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="rodzaj męski" data-expanded="rodzaj męski"><span class="short-content">m</span></span>
          </a>
        </span>
        / <a rel="mw:WikiLink" href="./hausšłvełł" title="hausšłvełł">hausšłvełł</a>
        <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt97" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
        <span class="short-container">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#M" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="rodzaj męski" data-expanded="rodzaj męski"><span class="short-content">m</span></span>
          </a>
        </span>
        , <a rel="mw:WikiLink" href="./haustjyr" title="haustjyr">haustjyr</a>
        <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt100" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
        <span class="short-container">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#Ż" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="rodzaj żeński" data-expanded="rodzaj żeński"><span class="short-content">ż</span></span>
          </a>
        </span>
      </dd>
    </dl>
    <span about="#mwt101" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"frazeologia","href":"./Szablon:frazeologia"},"params":{},"i":0}}]}' id="mwYA"> </span>
    <dl about="#mwt101">
      <dt>
        <span class="field field-title fld-frazeologia field-foreign" data-field="frazeologia" data-section-links="foreign">związki frazeologiczne<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt102" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"etymologia","href":"./Szablon:etymologia"},"params":{},"i":0}}]}' id="mwYQ"> </span>
    <dl about="#mwt102">
      <dt>
        <span class="field field-title fld-etymologia field-keep" data-field="etymologia" data-section-links="keep">etymologia<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <span about="#mwt103" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"uwagi","href":"./Szablon:uwagi"},"params":{},"i":0}},"\n: (1.1) zobacz też: [[Indeks:Wilamowski - Budynki i pomieszczenia]]"]}' id="mwYg">
    </span>
    <dl about="#mwt103">
      <dt>
        <span class="field field-title fld-uwagi field-keep" data-field="uwagi" data-section-links="keep">uwagi<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
      <dd>(1.1) zobacz też: <a rel="mw:WikiLink" href="./Indeks:Wilamowski_-_Budynki_i_pomieszczenia" title="Indeks:Wilamowski - Budynki i pomieszczenia">Indeks:Wilamowski - Budynki i pomieszczenia</a></dd>
    </dl>
    <span about="#mwt104" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"źródła","href":"./Szablon:źródła"},"params":{},"i":0}}]}' id="mwYw"> </span>
    <dl about="#mwt104">
      <dt>
        <span class="field field-title fld-zrodla field-keep" data-field="zrodla" data-section-links="keep" style="display: block; clear: left;">źródła<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <div class="mw-references-wrap" typeof="mw:Extension/references" about="#mwt106" data-mw='{"name":"references","attrs":{}}' id="mwZA">
      <ol class="mw-references references" id="mwZQ">
        <li about="#cite_note-2" id="cite_note-2">
          <a href="./haus#cite_ref-2" rel="mw:referencedBy" id="mwZg"><span class="mw-linkback-text" id="mwZw">↑ </span></a>
          <span id="mw-reference-text-cite_note-2" class="mw-reference-text">
            <figure-inline typeof="mw:Transclusion mw:Image" about="#mwt56" data-mw='{"parts":[{"template":{"target":{"wt":"Latosiński1909","href":"./Szablon:Latosiński1909"},"params":{"strony":{"wt":"286"}},"i":0}}]}' id="mwaA">
              <a href="./w:Otwarty_dostęp" id="mwaQ">
                <img
                  resource="./Plik:Open_Access_logo_PLoS_transparent.svg"
                  src="//upload.wikimedia.org/wikipedia/commons/thumb/7/77/Open_Access_logo_PLoS_transparent.svg/8px-Open_Access_logo_PLoS_transparent.svg.png"
                  data-file-width="640"
                  data-file-height="1000"
                  data-file-type="drawing"
                  height="13"
                  width="8"
                  srcset="
                    //upload.wikimedia.org/wikipedia/commons/thumb/7/77/Open_Access_logo_PLoS_transparent.svg/12px-Open_Access_logo_PLoS_transparent.svg.png 1.5x,
                    //upload.wikimedia.org/wikipedia/commons/thumb/7/77/Open_Access_logo_PLoS_transparent.svg/16px-Open_Access_logo_PLoS_transparent.svg.png 2x
                  "
                  id="mwag"
                />
              </a>
            </figure-inline>
            <span typeof="mw:Entity" about="#mwt56" id="mwaw">&nbsp;</span><span about="#mwt56" id="mwbA">Józef Latosiński, </span><span typeof="mw:Nowiki" about="#mwt56" id="mwbQ"></span>
            <i about="#mwt56" id="mwbg">
              <a rel="mw:ExtLink" href="http://dlibra.umcs.lublin.pl/dlibra/doccontent?id=7463&amp;from=FBC" class="external text" id="mwbw">Monografia miasteczka Wilamowic: na podstawie źródeł autentycznych: z ilustracyami i mapką</a>
            </i>
            <span about="#mwt56" id="mwcA">, Drukarnia Literacka pod zarządem L. K. Górskiego,</span><span typeof="mw:Entity" about="#mwt56" id="mwcQ"> </span><span about="#mwt56" id="mwcg">Kraków</span>
            <span typeof="mw:Entity" about="#mwt56" id="mwcw"> </span><span about="#mwt56" id="mwdA">1909, </span><span style="white-space: nowrap;" about="#mwt56" id="mwdQ">s. 286</span><span about="#mwt56" id="mwdg">.</span>
          </span>
        </li>
        <li about="#cite_note-3" id="cite_note-3">
          <a href="./haus#cite_ref-3" rel="mw:referencedBy" id="mwdw"><span class="mw-linkback-text" id="mweA">↑ </span></a>
          <span id="mw-reference-text-cite_note-3" class="mw-reference-text">
            <figure-inline
              typeof="mw:Transclusion mw:Image"
              about="#mwt59"
              data-mw='{"parts":[{"template":{"target":{"wt":"Mojmir1930","href":"./Szablon:Mojmir1930"},"params":{"część":{"wt":"A-R"},"strony":{"wt":"194"}},"i":0}}]}'
              id="mweQ"
            >
              <a href="./w:Otwarty_dostęp" id="mweg">
                <img
                  resource="./Plik:Open_Access_logo_PLoS_transparent.svg"
                  src="//upload.wikimedia.org/wikipedia/commons/thumb/7/77/Open_Access_logo_PLoS_transparent.svg/8px-Open_Access_logo_PLoS_transparent.svg.png"
                  data-file-width="640"
                  data-file-height="1000"
                  data-file-type="drawing"
                  height="13"
                  width="8"
                  srcset="
                    //upload.wikimedia.org/wikipedia/commons/thumb/7/77/Open_Access_logo_PLoS_transparent.svg/12px-Open_Access_logo_PLoS_transparent.svg.png 1.5x,
                    //upload.wikimedia.org/wikipedia/commons/thumb/7/77/Open_Access_logo_PLoS_transparent.svg/16px-Open_Access_logo_PLoS_transparent.svg.png 2x
                  "
                  id="mwew"
                />
              </a>
            </figure-inline>
            <span typeof="mw:Entity" about="#mwt59" id="mwfA">&nbsp;</span><span about="#mwt59" id="mwfQ">Hermann Mojmir, </span><span typeof="mw:Nowiki" about="#mwt59" id="mwfg"></span>
            <a rel="mw:ExtLink" href="https://polona.pl/item/worterbuch-der-deutschen-mundart-von-wilamowice-t-1-a-r,OTgwODIwNDk/2/#info:metadata" about="#mwt59" class="external text" id="mwfw">
              <i id="mwgA">Wörterbuch der deutschen Mundart von Wilamowice</i>
            </a>
            <span about="#mwt59" id="mwgQ">, </span><span style="white-space: nowrap;" about="#mwt59" id="mwgg">cz. A-R</span><span about="#mwt59" id="mwgw">, Polska Akademja Umiejętności,</span>
            <span typeof="mw:Entity" about="#mwt59" id="mwhA"> </span><span about="#mwt59" id="mwhQ">Kraków</span><span typeof="mw:Entity" about="#mwt59" id="mwhg"> </span><span about="#mwt59" id="mwhw">1930‒1936, </span>
            <span style="white-space: nowrap;" about="#mwt59" id="mwiA">s. 194</span><span about="#mwt59" id="mwiQ">.</span>
          </span>
        </li>
      </ol>
    </div>
  </section>
</div>
    HTML

    assert_includes actual.other_translations.keys, 'język indonezyjski'
    assert_includes actual.other_translations.keys, 'język wilamowski'
    assert_includes actual.other_translations['język indonezyjski'], 'spragniony'
    assert_includes actual.other_translations['język wilamowski'], 'dom, sień'
  end

  test 'it skips Polish as other_translations' do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język polski</span>
    </div>
  </div>
  <section data-mw-section-id="1" id="mwAw">
    <dl about="#mwt12">
      <dt>
        <span class="field field-title fld-znaczenia field-pl" data-field="znaczenia" data-section-links="pl">znaczenia<span typeof="mw:Entity">:</span></span>
      </dt>
      <dd></dd>
    </dl>
    <p id="mwEw"><i id="mwFA">rzeczownik, rodzaj męskorzeczowy</i></p>
    <dl id="mwFQ">
      <dd id="mwFg">
        (1.1)
        <style data-mw-deduplicate="TemplateStyles:r6240524" typeof="mw:Extension/templatestyles mw:Transclusion" about="#mwt13" data-mw='{"parts":[{"template":{"target":{"wt":"hand","href":"./Szablon:hand"},"params":{},"i":0}}]}' id="mwFw">
          .mw-parser-output .short-container {
            font-style: italic;
            text-decoration: none;
          }
          .mw-parser-output .short-no-style {
            font-style: normal;
          }
          .mw-parser-output .short-container a:hover {
            color: #002bb8;
            text-decoration: underline;
          }
          .mw-parser-output .short-container a,
          .mw-parser-output .short-container a:visited {
            color: black;
          }
          .mw-parser-output .short-variant1 a,
          .mw-parser-output .short-variant1 a:visited {
            color: #002bb8;
          }
          .mw-parser-output .short-variant2 a,
          .mw-parser-output .short-variant2 a:visited {
            color: red;
          }
          .mw-parser-output .short-variant3 a,
          .mw-parser-output .short-variant3 a:visited {
            color: green;
          }
        </style>
        <span class="short-container" about="#mwt13" id="mwGA">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#H" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="handel, handlowy" data-expanded="handel, handlowy"><span class="short-content">hand.</span></span>
          </a>
        </span>
        <a rel="mw:WikiLink" href="./pomieszczenie" title="pomieszczenie" id="mwGQ">pomieszczenie</a> <a rel="mw:WikiLink" href="./z" title="z" id="mwGg">z</a> <a rel="mw:WikiLink" href="./wejście" title="wejście" id="mwGw">wejściem</a>
        <a rel="mw:WikiLink" href="./od" title="od" id="mwHA">od</a> <a rel="mw:WikiLink" href="./ulica" title="ulica" id="mwHQ">ulicy</a>, <a rel="mw:WikiLink" href="./gdzie" title="gdzie" id="mwHg">gdzie</a>
        <a rel="mw:WikiLink" href="./sprzedawać" title="sprzedawać" id="mwHw">sprzedaje</a> <a rel="mw:WikiLink" href="./się" title="się" id="mwIA">się</a> <a rel="mw:WikiLink" href="./towar" title="towar" id="mwIQ">towary</a>
      </dd>
      <dd id="mwIg">
        (1.2)
        <link
          rel="mw-deduplicated-inline-style"
          href="mw-data:TemplateStyles:r6240524"
          about="#mwt19"
          typeof="mw:Extension/templatestyles mw:Transclusion"
          data-mw='{"parts":[{"template":{"target":{"wt":"daw","href":"./Szablon:daw"},"params":{},"i":0}}]}'
          id="mwIw"
        />
        <span class="short-container" about="#mwt19" id="mwJA">
          <a rel="mw:WikiLink" href="./Wikisłownik:Użycie_szablonów_daw,_hist,_przest,_stpol" title="Wikisłownik:Użycie szablonów daw, hist, przest, stpol">
            <span class="short-wrapper" title="dawniej, dawny" data-expanded="dawniej, dawny"><span class="short-content">daw.</span></span>
          </a>
        </span>
        <link
          rel="mw-deduplicated-inline-style"
          href="mw-data:TemplateStyles:r6240524"
          about="#mwt22"
          typeof="mw:Extension/templatestyles mw:Transclusion"
          data-mw='{"parts":[{"template":{"target":{"wt":"gw-pl","href":"./Szablon:gw-pl"},"params":{"1":{"wt":"Poznań"}},"i":0}}]}'
          id="mwJQ"
        />
        <span class="short-container" about="#mwt22">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#G" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="gwara, gwarowe" data-expanded="gwara, gwarowe"><span class="short-content">gw.</span></span>
          </a>
        </span>
        <span about="#mwt22"> </span>
        <i about="#mwt22">(<a rel="mw:WikiLink" href="./Kategoria:Dialektyzmy_polskie_-_Poznań" title="Kategoria:Dialektyzmy polskie - Poznań">Poznań</a><link rel="mw:PageProp/Category" href="./Kategoria:Dialektyzmy_polskie_-_Poznań" />)</i>
        <link rel="mw:PageProp/Category" href="./Kategoria:Dialektyzmy_polskie" about="#mwt22" id="mwJg" />
        <sup about="#mwt29" class="mw-ref reference" id="cite_ref-1" rel="dc:references" typeof="mw:Extension/ref" data-mw='{"name":"ref","attrs":{},"body":{"id":"mw-reference-text-cite_note-1"}}'>
          <a href="./sklep#cite_note-1" style="counter-reset: mw-Ref 1;" id="mwJw"><span class="mw-reflink-text" id="mwKA">[1]</span></a>
        </sup>
        ,
        <link
          rel="mw-deduplicated-inline-style"
          href="mw-data:TemplateStyles:r6240524"
          about="#mwt25"
          typeof="mw:Extension/templatestyles mw:Transclusion"
          data-mw='{"parts":[{"template":{"target":{"wt":"gw-pl","href":"./Szablon:gw-pl"},"params":{"1":{"wt":"Górny Śląsk, Mazury"}},"i":0}}]}'
          id="mwKQ"
        />
        <span class="short-container" about="#mwt25">
          <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#G" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
            <span class="short-wrapper" title="gwara, gwarowe" data-expanded="gwara, gwarowe"><span class="short-content">gw.</span></span>
          </a>
        </span>
        <span about="#mwt25"> </span>
        <i about="#mwt25">
          (<a rel="mw:WikiLink" href="./Kategoria:Dialektyzmy_polskie_-_Mazury" title="Kategoria:Dialektyzmy polskie - Mazury">Mazury</a><link rel="mw:PageProp/Category" href="./Kategoria:Dialektyzmy_polskie_-_Mazury" /> i
          <a rel="mw:WikiLink" href="./Kategoria:Dialektyzmy_polskie_-_Górny_Śląsk" title="Kategoria:Dialektyzmy polskie - Górny Śląsk">Górny Śląsk</a><link rel="mw:PageProp/Category" href="./Kategoria:Dialektyzmy_polskie_-_Górny_Śląsk" />)
        </i>
        <link rel="mw:PageProp/Category" href="./Kategoria:Dialektyzmy_polskie" about="#mwt25" id="mwKg" />
        <sup about="#mwt32" class="mw-ref reference" id="cite_ref-slask_2-0" rel="dc:references" typeof="mw:Extension/ref" data-mw='{"name":"ref","attrs":{"name":"slask"},"body":{"id":"mw-reference-text-cite_note-slask-2"}}'>
          <a href="./sklep#cite_note-slask-2" style="counter-reset: mw-Ref 2;" id="mwKw"><span class="mw-reflink-text" id="mwLA">[2]</span></a>
        </sup>
        <sup about="#mwt33" class="mw-ref reference" id="cite_ref-3" rel="dc:references" typeof="mw:Extension/ref" data-mw='{"name":"ref","attrs":{},"body":{"id":"mw-reference-text-cite_note-3"}}'>
          <a href="./sklep#cite_note-3" style="counter-reset: mw-Ref 3;" id="mwLQ"><span class="mw-reflink-text" id="mwLg">[3]</span></a>
        </sup>
        <a rel="mw:WikiLink" href="./piwnica" title="piwnica" id="mwLw">piwnica</a>
      </dd>
      <dd id="mwMA">
        (1.3)
        <link
          rel="mw-deduplicated-inline-style"
          href="mw-data:TemplateStyles:r6240524"
          about="#mwt34"
          typeof="mw:Extension/templatestyles mw:Transclusion"
          data-mw='{"parts":[{"template":{"target":{"wt":"daw","href":"./Szablon:daw"},"params":{},"i":0}}]}'
          id="mwMQ"
        />
        <span class="short-container" about="#mwt34" id="mwMg">
          <a rel="mw:WikiLink" href="./Wikisłownik:Użycie_szablonów_daw,_hist,_przest,_stpol" title="Wikisłownik:Użycie szablonów daw, hist, przest, stpol">
            <span class="short-wrapper" title="dawniej, dawny" data-expanded="dawniej, dawny"><span class="short-content">daw.</span></span>
          </a>
        </span>
        <a rel="mw:WikiLink" href="./sufit" title="sufit" id="mwMw">sufit</a>
      </dd>
    </dl>
  </section>
</div>
    HTML

    assert_equal 0, actual.other_translations.size
  end

  test "it skips Polish sign language in other_translations" do
    actual = ParseHtml.new.call(<<-HTML)
<div>
  <div>
    <div>
      <span>język polski</span>
    </div>
  </div>
  <section data-mw-section-id="1" id="mwAw">
    <li id="mwARI">
      polski język migowy:
      <div
        class="NavFrame collapse-sign-language"
        style="display: inline;"
        about="#mwt271"
        typeof="mw:Transclusion"
        data-mw='{"parts":[{"template":{"target":{"wt":"PJM-ukryj","href":"./Szablon:PJM-ukryj"},"params":{"1":{"wt":" (1.1) {{PJM|dziewczyna}} {{,}} {{PJM|dziewczyna 2}}"}},"i":0}}]}'
        id="mwARM"
      >
        <i>(w zapisie <a rel="mw:WikiLink/Interwiki" href="https://pl.wikipedia.org/wiki/SignWriting" title="w:SignWriting">SignWriting</a>)</i>
        <div class="NavHead" style="background: transparent; text-align: left; padding-right: 55px; display: inline;"></div>
        <div class="NavContent" style="text-align: left; display: block;">
          (1.1)
          <span class="mw-default-size" typeof="mw:Image">
            <a href="./Plik:SGN-PL_SW_dziewczyna.PNG">
              <img resource="./Plik:SGN-PL_SW_dziewczyna.PNG" src="//upload.wikimedia.org/wikipedia/commons/6/6c/SGN-PL_SW_dziewczyna.PNG" data-file-width="66" data-file-height="45" data-file-type="bitmap" height="45" width="66" />
            </a>
          </span>
          <link rel="mw:PageProp/Category" href="./Kategoria:polski_język_migowy_(indeks)" /> <span typeof="mw:Entity">&nbsp;</span><span style="font-size: xx-large;">,</span><span typeof="mw:Entity">&nbsp;</span>
          <span typeof="mw:Entity">&nbsp;</span><span typeof="mw:Entity">&nbsp;</span><span typeof="mw:Entity">&nbsp;</span>
          <span class="mw-default-size" typeof="mw:Image">
            <a href="./Plik:SGN-PL_SW_dziewczyna_2.PNG">
              <img resource="./Plik:SGN-PL_SW_dziewczyna_2.PNG" src="//upload.wikimedia.org/wikipedia/commons/e/e7/SGN-PL_SW_dziewczyna_2.PNG" data-file-width="62" data-file-height="47" data-file-type="bitmap" height="47" width="62" />
            </a>
          </span>
          <link rel="mw:PageProp/Category" href="./Kategoria:polski_język_migowy_(indeks)" />
        </div>
      </div>
    </li>
  </section>
</div>
    HTML

    assert_equal 0, actual.other_translations.size
  end

  test "it skips styles in other_translations" do
    actual = ParseHtml.new.call(<<-HTML)
<section data-mw-section-id="1" id="mwAg">
  <h2 id="rosso_(język_włoski)">
    <span id="rosso_.28j.C4.99zyk_w.C5.82oski.29" typeof="mw:FallbackId"></span>rosso (
    <span class="lang-code primary-lang-code lang-code-it" id="it" about="#mwt2" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"język włoski","href":"./Szablon:język_włoski"},"params":{},"i":0}}]}'>
      <a rel="mw:WikiLink" href="./Słownik_języka_włoskiego" title="Słownik języka włoskiego">język włoski</a>
    </span>
    <link rel="mw:PageProp/Category" href="./Kategoria:włoski_(indeks)" about="#mwt2" /><link rel="mw:PageProp/Category" href="./Kategoria:włoski_(indeks_a_tergo)#ossor" about="#mwt2" />
    <link rel="mw:PageProp/Category" href="./Kategoria:Język_włoski_-_rzeczowniki" about="#mwt2" /><link rel="mw:PageProp/Category" href="./Kategoria:Język_włoski_-_rzeczowniki_rodzaju_męskiego" about="#mwt2" />
    <link rel="mw:PageProp/Category" href="./Kategoria:Język_włoski_-_przymiotniki" about="#mwt2" id="mwAw" />)
  </h2>
  <div class="tright" about="#mwt3" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"kolor","href":"./Szablon:kolor"},"params":{"1":{"wt":"red"},"2":{"wt":"rosso (1.1, 2.1)"}},"i":0}}]}' id="mwBA">
    <table>
      <tbody>
        <tr>
          <td style="width: 225px; height: 50px; background-color: red; text-align: center; color: white;">rosso (1.1, 2.1)</td>
        </tr>
      </tbody>
    </table>
  </div>
  <span
    about="#mwt4"
    typeof="mw:Transclusion"
    data-mw='{"parts":[{"template":{"target":{"wt":"wymowa","href":"./Szablon:wymowa"},"params":{},"i":0}},"\n: ",{"template":{"target":{"wt":"IPA3","href":"./Szablon:IPA3"},"params":{"1":{"wt":"ˈros.so"}},"i":1}},", ",{"template":{"target":{"wt":"audio","href":"./Szablon:audio"},"params":{"1":{"wt":"It-rosso.ogg"}},"i":2}},"\n: ",{"template":{"target":{"wt":"audio","href":"./Szablon:audio"},"params":{"1":{"wt":"It-rosso.oga"}},"i":3}}]}'
    id="mwBQ"
  >
  </span>
  <dl about="#mwt4">
    <dt>
      <span class="field field-title fld-wymowa field-keep" data-field="wymowa" data-section-links="keep">wymowa<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
    <dd>
      <a rel="mw:WikiLink" href="./Aneks:IPA" title="Aneks:IPA">IPA</a>:<span typeof="mw:Entity">&nbsp;</span>
      <style data-mw-deduplicate="TemplateStyles:r6239616" typeof="mw:Extension/templatestyles" about="#mwt7" data-mw='{"name":"templatestyles","attrs":{"src":"ZapisIPA/styles.css"}}'>
        .mw-parser-output .ipa {
          white-space: nowrap;
          font-family: "Charis SIL", "Doulos SIL", Junicode, "TITUS Cyberbit Basic", "DejaVu Sans", "DejaVu Sans Condensed", Gentium, GentiumAlt, LeedsUni, "Arial Unicode MS", "DejaVu Serif", "DejaVu Serif Condensed", SImPL, Thryomanes,
            Code2000, "Hindsight Unicode";
          font-size: 110%;
        }
      </style>
      <span title="To jest wymowa w zapisie IPA; zobacz hasło IPA w Wikipedii" class="ipa">[ˈros.so]</span>,
      <style data-mw-deduplicate="TemplateStyles:r7249982" typeof="mw:Extension/templatestyles" about="#mwt10" data-mw='{"name":"templatestyles","attrs":{"src":"audio/styles.css"}}'>
        .mw-parser-output .audiolink a {
          background: url("//upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Loudspeaker.svg/16px-Loudspeaker.svg.png") center left no-repeat !important;
          padding-left: 20px !important;
          padding-right: 0 !important;
        }
        .mw-parser-output .audioinfo {
          font-family: monospace, "Courier";
        }
      </style>
      <span class="audiolink">
        <a rel="mw:MediaLink" href="//upload.wikimedia.org/wikipedia/commons/f/fd/It-rosso.ogg" resource="./Media:It-rosso.ogg" title="It-rosso.ogg"><span typeof="mw:Entity">​</span></a>
      </span>
      <span class="noprint">
        <sup>
          <a rel="mw:WikiLink/Interwiki" href="https://commons.wikimedia.org/wiki/Commons:Pomoc%20-%20multimedia" title="commons:Commons:Pomoc - multimedia">?</a>/
          <a rel="mw:WikiLink" href="./Plik:It-rosso.ogg" title="Plik:It-rosso.ogg"><span class="audioinfo">i</span></a>
        </sup>
      </span>
    </dd>
    <dd>
      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r7249982" about="#mwt13" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"audio/styles.css"}}' />
      <span class="audiolink">
        <a rel="mw:MediaLink" href="//upload.wikimedia.org/wikipedia/commons/4/49/It-rosso.oga" resource="./Media:It-rosso.oga" title="It-rosso.oga"><span typeof="mw:Entity">​</span></a>
      </span>
      <span class="noprint">
        <sup>
          <a rel="mw:WikiLink/Interwiki" href="https://commons.wikimedia.org/wiki/Commons:Pomoc%20-%20multimedia" title="commons:Commons:Pomoc - multimedia">?</a>/
          <a rel="mw:WikiLink" href="./Plik:It-rosso.oga" title="Plik:It-rosso.oga"><span class="audioinfo">i</span></a>
        </sup>
      </span>
    </dd>
  </dl>
  <span about="#mwt14" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"znaczenia","href":"./Szablon:znaczenia"},"params":{},"i":0}}]}' id="mwBg"> </span>
  <dl about="#mwt14">
    <dt>
      <span class="field field-title fld-znaczenia field-pl" data-field="znaczenia" data-section-links="pl">znaczenia<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
  </dl>
  <p id="mwBw"><i id="mwCA">rzeczownik, rodzaj męski</i></p>
  <dl id="mwCQ">
    <dd id="mwCg">
      (1.1) <a rel="mw:WikiLink" href="./kolor" title="kolor" id="mwCw">kolor</a> <a rel="mw:WikiLink" href="./czerwony" title="czerwony" id="mwDA">czerwony</a>, <a rel="mw:WikiLink" href="./czerwień" title="czerwień" id="mwDQ">czerwień</a>
    </dd>
    <dd id="mwDg">(1.2) <a rel="mw:WikiLink" href="./rudzielec" title="rudzielec" id="mwDw">rudzielec</a>, <a rel="mw:WikiLink" href="./ryży" title="ryży" id="mwEA">ryży</a></dd>
    <dd id="mwEQ">
      (1.3)
      <style
        data-mw-deduplicate="TemplateStyles:r6240524"
        typeof="mw:Extension/templatestyles mw:Transclusion"
        about="#mwt15"
        data-mw='{"parts":[{"template":{"target":{"wt":"polit","href":"./Szablon:polit"},"params":{},"i":0}}]}'
        id="mwEg"
      >
        .mw-parser-output .short-container {
          font-style: italic;
          text-decoration: none;
        }
        .mw-parser-output .short-no-style {
          font-style: normal;
        }
        .mw-parser-output .short-container a:hover {
          color: #002bb8;
          text-decoration: underline;
        }
        .mw-parser-output .short-container a,
        .mw-parser-output .short-container a:visited {
          color: black;
        }
        .mw-parser-output .short-variant1 a,
        .mw-parser-output .short-variant1 a:visited {
          color: #002bb8;
        }
        .mw-parser-output .short-variant2 a,
        .mw-parser-output .short-variant2 a:visited {
          color: red;
        }
        .mw-parser-output .short-variant3 a,
        .mw-parser-output .short-variant3 a:visited {
          color: green;
        }
      </style>
      <span class="short-container" about="#mwt15" id="mwEw">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#P" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="politologia, polityka, politologiczny, polityczny" data-expanded="politologia, polityka, politologiczny, polityczny"><span class="short-content">polit.</span></span>
        </a>
      </span>
      <a rel="mw:WikiLink" href="./czerwony" title="czerwony" id="mwFA">czerwony</a>, <a rel="mw:WikiLink" href="./lewicowiec" title="lewicowiec" id="mwFQ">lewicowiec</a>
    </dd>
  </dl>
  <p id="mwFg"><i id="mwFw">przymiotnik</i></p>
  <dl id="mwGA">
    <dd id="mwGQ">(2.1) <a rel="mw:WikiLink" href="./czerwony" title="czerwony" id="mwGg">czerwony</a></dd>
  </dl>
  <span
    about="#mwt18"
    typeof="mw:Transclusion"
    data-mw='{"parts":[{"template":{"target":{"wt":"odmiana","function":"grammar"},"params":{},"i":0}},"\n: (1) ",{"template":{"target":{"wt":"lp","href":"./Szablon:lp"},"params":{},"i":1}}," rosso; ",{"template":{"target":{"wt":"lm","href":"./Szablon:lm"},"params":{},"i":2}}," rossi\n: (2) ",{"template":{"target":{"wt":"lp","href":"./Szablon:lp"},"params":{},"i":3}}," rosso ",{"template":{"target":{"wt":"m","href":"./Szablon:m"},"params":{},"i":4}},", rossa ",{"template":{"target":{"wt":"ż","href":"./Szablon:ż"},"params":{},"i":5}},"; ",{"template":{"target":{"wt":"lm","href":"./Szablon:lm"},"params":{},"i":6}}," rossi ",{"template":{"target":{"wt":"m","href":"./Szablon:m"},"params":{},"i":7}},", rosse ",{"template":{"target":{"wt":"ż","href":"./Szablon:ż"},"params":{},"i":8}}]}'
    id="mwGw"
  >
  </span>
  <dl about="#mwt18">
    <dt>
      <span class="field field-title fld-odmiana field-foreign" data-field="odmiana" data-section-links="foreign">
        <a rel="mw:WikiLink" href="./Wikisłownik:Zasady_tworzenia_haseł/Odmiana" title="Wikisłownik:Zasady tworzenia haseł/Odmiana">odmiana</a><span typeof="mw:Entity">:</span>
      </span>
    </dt>
    <dd></dd>
    <dd>
      (1) <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt22" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container short-variant1" about="#mwt23" typeof="mw:ExpandedAttrs" data-mw='{"attribs":[[{"txt":"class"},{"html":"short-container<span typeof=\"mw:Nowiki\" data-parsoid=\"{}\"></span> short-variant1"}]]}'>
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#L" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="liczba pojedyncza" data-expanded="liczba pojedyncza"><span class="short-content">lp</span></span>
        </a>
      </span>
      rosso; <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt27" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container short-variant1" about="#mwt28" typeof="mw:ExpandedAttrs" data-mw='{"attribs":[[{"txt":"class"},{"html":"short-container<span typeof=\"mw:Nowiki\" data-parsoid=\"{}\"></span> short-variant1"}]]}'>
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#L" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="liczba mnoga" data-expanded="liczba mnoga"><span class="short-content">lm</span></span>
        </a>
      </span>
      rossi
    </dd>
    <dd>
      (2) <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt32" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container short-variant1" about="#mwt33" typeof="mw:ExpandedAttrs" data-mw='{"attribs":[[{"txt":"class"},{"html":"short-container<span typeof=\"mw:Nowiki\" data-parsoid=\"{}\"></span> short-variant1"}]]}'>
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#L" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="liczba pojedyncza" data-expanded="liczba pojedyncza"><span class="short-content">lp</span></span>
        </a>
      </span>
      rosso <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt36" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#M" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="rodzaj męski" data-expanded="rodzaj męski"><span class="short-content">m</span></span>
        </a>
      </span>
      , rossa <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt39" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#Ż" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="rodzaj żeński" data-expanded="rodzaj żeński"><span class="short-content">ż</span></span>
        </a>
      </span>
      ; <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt43" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container short-variant1" about="#mwt44" typeof="mw:ExpandedAttrs" data-mw='{"attribs":[[{"txt":"class"},{"html":"short-container<span typeof=\"mw:Nowiki\" data-parsoid=\"{}\"></span> short-variant1"}]]}'>
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#L" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="liczba mnoga" data-expanded="liczba mnoga"><span class="short-content">lm</span></span>
        </a>
      </span>
      rossi <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt47" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#M" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="rodzaj męski" data-expanded="rodzaj męski"><span class="short-content">m</span></span>
        </a>
      </span>
      , rosse <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt50" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#Ż" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="rodzaj żeński" data-expanded="rodzaj żeński"><span class="short-content">ż</span></span>
        </a>
      </span>
    </dd>
  </dl>
  <span
    about="#mwt51"
    typeof="mw:Transclusion"
    data-mw="{&quot;parts&quot;:[{&quot;template&quot;:{&quot;target&quot;:{&quot;wt&quot;:&quot;przykłady&quot;,&quot;href&quot;:&quot;./Szablon:przykłady&quot;},&quot;params&quot;:{},&quot;i&quot;:0}},&quot;\n: (2.1) ''[[rosso|Rosso]] [[come]] [[il]] [[sangue]].'' → '''[[czerwony|Czerwony]]''' [[jak]] [[krew]].\n: (2.1) ''[[avere|Avevo]] [[una]] [[bicicletta]] [[rosso|rossa]].'' → [[mieć|Miałem]] '''[[czerwony]]''' [[rower]].&quot;]}"
    id="mwHA"
  >
  </span>
  <dl about="#mwt51">
    <dt>
      <span class="field field-title fld-przyklady field-exampl" data-field="przyklady" data-section-links="exampl" style="display: block; clear: left;">przykłady<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
    <dd>
      (2.1)
      <i>
        <a rel="mw:WikiLink" href="./rosso" title="rosso">Rosso</a> <a rel="mw:WikiLink" href="./come" title="come">come</a> <a rel="mw:WikiLink" href="./il" title="il">il</a> <a rel="mw:WikiLink" href="./sangue" title="sangue">sangue</a>.
      </i>
      → <b><a rel="mw:WikiLink" href="./czerwony" title="czerwony">Czerwony</a></b> <a rel="mw:WikiLink" href="./jak" title="jak">jak</a> <a rel="mw:WikiLink" href="./krew" title="krew">krew</a>.
    </dd>
    <dd>
      (2.1)
      <i>
        <a rel="mw:WikiLink" href="./avere" title="avere">Avevo</a> <a rel="mw:WikiLink" href="./una" title="una">una</a> <a rel="mw:WikiLink" href="./bicicletta" title="bicicletta">bicicletta</a>
        <a rel="mw:WikiLink" href="./rosso" title="rosso">rossa</a>.
      </i>
      → <a rel="mw:WikiLink" href="./mieć" title="mieć">Miałem</a> <b><a rel="mw:WikiLink" href="./czerwony" title="czerwony">czerwony</a></b> <a rel="mw:WikiLink" href="./rower" title="rower">rower</a>.
    </dd>
  </dl>
  <span about="#mwt52" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"składnia","href":"./Szablon:składnia"},"params":{},"i":0}}]}' id="mwHQ"> </span>
  <dl about="#mwt52">
    <dt>
      <span class="field field-title fld-skladnia field-foreign" data-field="skladnia" data-section-links="foreign">składnia<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
  </dl>
  <span
    about="#mwt53"
    typeof="mw:Transclusion"
    data-mw='{"parts":[{"template":{"target":{"wt":"kolokacje","href":"./Szablon:kolokacje"},"params":{},"i":0}},"\n: (2.1) &apos;&apos;[[capello|capelli]] rossi&apos;&apos; → [[rudy|rude]] [[włos]]y"]}'
    id="mwHg"
  >
  </span>
  <dl about="#mwt53">
    <dt>
      <span class="field field-title fld-kolokacje field-foreign" data-field="kolokacje" data-section-links="foreign">
        <a rel="mw:WikiLink" href="./Wikisłownik:ZTH_kolokacje" title="Wikisłownik:ZTH kolokacje" class="mw-redirect">kolokacje</a><span typeof="mw:Entity">:</span>
      </span>
    </dt>
    <dd></dd>
    <dd>
      (2.1) <i><a rel="mw:WikiLink" href="./capello" title="capello">capelli</a> rossi</i> → <a rel="mw:WikiLink" href="./rudy" title="rudy">rude</a> <a rel="mw:WikiLink" href="./włos" title="włos">włosy</a>
    </dd>
  </dl>
  <span about="#mwt54" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"synonimy","href":"./Szablon:synonimy"},"params":{},"i":0}}]}' id="mwHw"> </span>
  <dl about="#mwt54">
    <dt>
      <span class="field field-title fld-synonimy field-foreign" data-field="synonimy" data-section-links="foreign">synonimy<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
  </dl>
  <span about="#mwt55" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"antonimy","href":"./Szablon:antonimy"},"params":{},"i":0}}]}' id="mwIA"> </span>
  <dl about="#mwt55">
    <dt>
      <span class="field field-title fld-antonimy field-foreign" data-field="antonimy" data-section-links="foreign">antonimy<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
  </dl>
  <span about="#mwt56" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"hiperonimy","href":"./Szablon:hiperonimy"},"params":{},"i":0}}]}' id="mwIQ"> </span>
  <dl about="#mwt56">
    <dt>
      <span class="field field-title fld-hiperonimy field-foreign" data-field="hiperonimy" data-section-links="foreign">hiperonimy<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
  </dl>
  <span about="#mwt57" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"hiponimy","href":"./Szablon:hiponimy"},"params":{},"i":0}}]}' id="mwIg"> </span>
  <dl about="#mwt57">
    <dt>
      <span class="field field-title fld-hiponimy field-foreign" data-field="hiponimy" data-section-links="foreign">hiponimy<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
  </dl>
  <span about="#mwt58" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"holonimy","href":"./Szablon:holonimy"},"params":{},"i":0}}]}' id="mwIw"> </span>
  <dl about="#mwt58">
    <dt>
      <span class="field field-title fld-holonimy field-foreign" data-field="holonimy" data-section-links="foreign">holonimy<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
  </dl>
  <span about="#mwt59" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"meronimy","href":"./Szablon:meronimy"},"params":{},"i":0}}]}' id="mwJA"> </span>
  <dl about="#mwt59">
    <dt>
      <span class="field field-title fld-meronimy field-foreign" data-field="meronimy" data-section-links="foreign">meronimy<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
  </dl>
  <span
    about="#mwt60"
    typeof="mw:Transclusion"
    data-mw='{"parts":[{"template":{"target":{"wt":"pokrewne","href":"./Szablon:pokrewne"},"params":{},"i":0}},"\n: ",{"template":{"target":{"wt":"rzecz","href":"./Szablon:rzecz"},"params":{},"i":1}}," [[rossello]] ",{"template":{"target":{"wt":"m","href":"./Szablon:m"},"params":{},"i":2}},", [[rossetto]] ",{"template":{"target":{"wt":"m","href":"./Szablon:m"},"params":{},"i":3}},", [[rossezza]] ",{"template":{"target":{"wt":"ż","href":"./Szablon:ż"},"params":{},"i":4}},", [[rossiccio]] ",{"template":{"target":{"wt":"m","href":"./Szablon:m"},"params":{},"i":5}},", [[rossola]] ",{"template":{"target":{"wt":"ż","href":"./Szablon:ż"},"params":{},"i":6}},", [[rossore]] ",{"template":{"target":{"wt":"m","href":"./Szablon:m"},"params":{},"i":7}},"\n: ",{"template":{"target":{"wt":"czas","href":"./Szablon:czas"},"params":{},"i":8}}," [[rosseggiare]]\n: ",{"template":{"target":{"wt":"przym","href":"./Szablon:przym"},"params":{},"i":9}}," [[rossastro]], [[rossiccio]], [[rossigno]], [[rossino]]"]}'
    id="mwJQ"
  >
  </span>
  <dl about="#mwt60">
    <dt>
      <span class="field field-title fld-pokrewne field-foreign" data-field="pokrewne" data-section-links="foreign">wyrazy pokrewne<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
    <dd>
      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt63" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#R" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="rzeczownik" data-expanded="rzeczownik"><span class="short-content">rzecz.</span></span>
        </a>
      </span>
      <a rel="mw:WikiLink" href="./rossello" title="rossello" class="new">rossello</a>
      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt66" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#M" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="rodzaj męski" data-expanded="rodzaj męski"><span class="short-content">m</span></span>
        </a>
      </span>
      , <a rel="mw:WikiLink" href="./rossetto" title="rossetto">rossetto</a>
      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt69" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#M" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="rodzaj męski" data-expanded="rodzaj męski"><span class="short-content">m</span></span>
        </a>
      </span>
      , <a rel="mw:WikiLink" href="./rossezza" title="rossezza" class="new">rossezza</a>
      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt72" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#Ż" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="rodzaj żeński" data-expanded="rodzaj żeński"><span class="short-content">ż</span></span>
        </a>
      </span>
      , <a rel="mw:WikiLink" href="./rossiccio" title="rossiccio">rossiccio</a>
      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt75" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#M" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="rodzaj męski" data-expanded="rodzaj męski"><span class="short-content">m</span></span>
        </a>
      </span>
      , <a rel="mw:WikiLink" href="./rossola" title="rossola" class="new">rossola</a>
      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt78" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#Ż" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="rodzaj żeński" data-expanded="rodzaj żeński"><span class="short-content">ż</span></span>
        </a>
      </span>
      , <a rel="mw:WikiLink" href="./rossore" title="rossore">rossore</a>
      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt81" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#M" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="rodzaj męski" data-expanded="rodzaj męski"><span class="short-content">m</span></span>
        </a>
      </span>
    </dd>
    <dd>
      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt84" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#C" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="czasownik" data-expanded="czasownik"><span class="short-content">czas.</span></span>
        </a>
      </span>
      <a rel="mw:WikiLink" href="./rosseggiare" title="rosseggiare" class="new">rosseggiare</a>
    </dd>
    <dd>
      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt87" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Aneks:Skróty_używane_w_Wikisłowniku#P" title="Aneks:Skróty używane w Wikisłowniku" class="mw-redirect">
          <span class="short-wrapper" title="przymiotnik" data-expanded="przymiotnik"><span class="short-content">przym.</span></span>
        </a>
      </span>
      <a rel="mw:WikiLink" href="./rossastro" title="rossastro">rossastro</a>, <a rel="mw:WikiLink" href="./rossiccio" title="rossiccio">rossiccio</a>, <a rel="mw:WikiLink" href="./rossigno" title="rossigno" class="new">rossigno</a>,
      <a rel="mw:WikiLink" href="./rossino" title="rossino" class="new">rossino</a>
    </dd>
  </dl>
  <span about="#mwt88" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"frazeologia","href":"./Szablon:frazeologia"},"params":{},"i":0}}]}' id="mwJg"> </span>
  <dl about="#mwt88">
    <dt>
      <span class="field field-title fld-frazeologia field-foreign" data-field="frazeologia" data-section-links="foreign">związki frazeologiczne<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
  </dl>
  <span
    about="#mwt89"
    typeof="mw:Transclusion"
    data-mw='{"parts":[{"template":{"target":{"wt":"etymologia","href":"./Szablon:etymologia"},"params":{},"i":0}},"\n: ",{"template":{"target":{"wt":"etym2","href":"./Szablon:etym2"},"params":{"1":{"wt":"łac"},"2":{"wt":"russus"},"3":{"wt":"rŭssus"}},"i":1}},"<ref>{{Treccani}}</ref>"]}'
    id="mwJw"
  >
  </span>
  <dl about="#mwt89">
    <dt>
      <span class="field field-title fld-etymologia field-keep" data-field="etymologia" data-section-links="keep">etymologia<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
    <dd>
      <link rel="mw-deduplicated-inline-style" href="mw-data:TemplateStyles:r6240524" about="#mwt93" typeof="mw:Extension/templatestyles" data-mw='{"name":"templatestyles","attrs":{"src":"skrót/styles.css"}}' />
      <span class="short-container">
        <a rel="mw:WikiLink" href="./Kategoria:Język_łaciński" title="Kategoria:Język łaciński">
          <span class="short-wrapper" title="łacina" data-expanded="łacina"><span class="short-content">łac.</span></span>
        </a>
      </span>
      <a rel="mw:WikiLink" href="./russus#russus_(język_łaciński)" title="russus" class="new">rŭssus</a><link rel="mw:PageProp/Category" href="./Kategoria:Język_łaciński_w_etymologii" />
      <sup about="#mwt95" class="mw-ref reference" id="cite_ref-1" rel="dc:references" typeof="mw:Extension/ref" data-mw='{"name":"ref","attrs":{},"body":{"id":"mw-reference-text-cite_note-1"}}'>
        <a href="./rosso#cite_note-1" style="counter-reset: mw-Ref 1;" id="mwKA"><span class="mw-reflink-text" id="mwKQ">[1]</span></a>
      </sup>
    </dd>
  </dl>
  <span about="#mwt96" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"uwagi","href":"./Szablon:uwagi"},"params":{},"i":0}},"\n: (2.1) zobacz też: [[Indeks:Włoski - Kolory]]"]}' id="mwKg"> </span>
  <dl about="#mwt96">
    <dt>
      <span class="field field-title fld-uwagi field-keep" data-field="uwagi" data-section-links="keep">uwagi<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
    <dd>(2.1) zobacz też: <a rel="mw:WikiLink" href="./Indeks:Włoski_-_Kolory" title="Indeks:Włoski - Kolory">Indeks:Włoski - Kolory</a></dd>
  </dl>
  <span about="#mwt97" typeof="mw:Transclusion" data-mw='{"parts":[{"template":{"target":{"wt":"źródła","href":"./Szablon:źródła"},"params":{},"i":0}}]}' id="mwKw"> </span>
  <dl about="#mwt97">
    <dt>
      <span class="field field-title fld-zrodla field-keep" data-field="zrodla" data-section-links="keep" style="display: block; clear: left;">źródła<span typeof="mw:Entity">:</span></span>
    </dt>
    <dd></dd>
  </dl>
  <div class="mw-references-wrap" typeof="mw:Extension/references" about="#mwt99" data-mw='{"name":"references","attrs":{}}' id="mwLA">
    <ol class="mw-references references" id="mwLQ">
      <li about="#cite_note-1" id="cite_note-1">
        <a href="./rosso#cite_ref-1" rel="mw:referencedBy" id="mwLg"><span class="mw-linkback-text" id="mwLw">↑ </span></a>
        <span id="mw-reference-text-cite_note-1" class="mw-reference-text">
          <a
            rel="mw:ExtLink"
            href="http://www.treccani.it/vocabolario/"
            about="#mwt94"
            typeof="mw:Transclusion"
            class="external text"
            data-mw='{"parts":[{"template":{"target":{"wt":"Treccani","href":"./Szablon:Treccani"},"params":{},"i":0}}]}'
            id="mwMA"
          >
            treccani.it
          </a>
          <span about="#mwt94" id="mwMQ">.</span>
        </span>
      </li>
    </ol>
  </div>
</section>
    HTML

    assert_includes actual.other_translations['język włoski'], "polit.czerwony, lewicowiec"
  end
end
