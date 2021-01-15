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

  test 'it parses examples' do
    actual = ParseHtml.new.call(<<-HTML)
<dl about="#mwt45">
  <dt><span class="field field-title fld-przyklady field-exampl" data-field="przyklady" data-section-links="exampl" style="display:block; clear:left;">przykłady<span typeof="mw:Entity">:</span></span></dt>
  <dd></dd>
  <dd>(1.1) <i><a rel="mw:WikiLink" href="./z" title="z">Z</a> <a rel="mw:WikiLink" href="./drzewo" title="drzewo">drzewa</a> <a rel="mw:WikiLink" href="./spaść" title="spaść">spadł</a> <a rel="mw:WikiLink" href="./już" title="już">już</a> <a rel="mw:WikiLink" href="./ostatni" title="ostatni">ostatni</a> <a rel="mw:WikiLink" href="./liść" title="liść">liść</a>.</i></dd>
  <dd>(1.1) <i><a rel="mw:WikiLink" href="./liść" title="liść">Liście</a> <a rel="mw:WikiLink" href="./trawa" title="trawa">traw</a> <a rel="mw:WikiLink" href="./dzielić_się" title="dzielić się" class="mw-redirect">dzielą się</a> <a rel="mw:WikiLink" href="./na" title="na">na</a> <a rel="mw:WikiLink" href="./pochwa" title="pochwa">pochwy</a> <a rel="mw:WikiLink" href="./i" title="i">i</a> <a rel="mw:WikiLink" href="./języczek" title="języczek">języczki</a>.</i></dd>
  <dd>(1.2) <i><a rel="mw:WikiLink" href="./w" title="w">W</a> <a rel="mw:WikiLink" href="./drzewo" title="drzewo">drzewie</a> <a rel="mw:WikiLink" href="./katalog" title="katalog">katalogów</a> <a rel="mw:WikiLink" href="./liść" title="liść">liśćmi</a> <a rel="mw:WikiLink" href="./być" title="być">są</a> <a rel="mw:WikiLink" href="./plik" title="plik">pliki</a>.</i></dd>
  <dd>(1.3) <i><a rel="mw:WikiLink" href="./gdy" title="gdy">Gdy</a> <a rel="mw:WikiLink" href="./wyznać" title="wyznać">wyznał</a> <a rel="mw:WikiLink" href="./ona" title="ona">jej</a>, <a rel="mw:WikiLink" href="./że" title="że">że</a> <a rel="mw:WikiLink" href="./od" title="od">od</a> <a rel="mw:WikiLink" href="./długi" title="długi">dłuższego</a> <a rel="mw:WikiLink" href="./czas" title="czas">czasu</a> <a rel="mw:WikiLink" href="./mieć" title="mieć">ma</a> <a rel="mw:WikiLink" href="./kochanka" title="kochanka">kochankę</a>, <a rel="mw:WikiLink" href="./dać" title="dać">dała</a> <a rel="mw:WikiLink" href="./on" title="on">mu</a> <a rel="mw:WikiLink" href="./z" title="z">z</a> <a rel="mw:WikiLink" href="./liść" title="liść">liścia</a> <a rel="mw:WikiLink" href="./w" title="w">w</a> <a rel="mw:WikiLink" href="./twarz" title="twarz">twarz</a>.</i></dd>
</dl>
    HTML

    assert_equal 4, actual.examples.size
    assert_includes actual.examples, 'Z drzewa spadł już ostatni liść.'
    assert_includes actual.examples, 'Liście traw dzielą się na pochwy i języczki.'
    assert_includes actual.examples, 'W drzewie katalogów liśćmi są pliki.'
    assert_includes actual.examples, 'Gdy wyznał jej, że od dłuższego czasu ma kochankę, dała mu z liścia w twarz.'
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
end
