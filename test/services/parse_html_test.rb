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
end
