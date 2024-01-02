require 'test_helper'

class ParseBablaHtmlTest < ActiveSupport::TestCase
  test 'it parses translations for podkręcić' do
    html = File.read('test/htmls/babla/podkręcić.html')

    actual = ParseBablaHtml.new.call(html, 'podkręcić')

    assert_equal 8, actual.size
    assert_includes actual, 'crank up'
    assert_includes actual, 'overclock'
    assert_includes actual, 'gun'
    assert_includes actual, 'pump up'
    assert_includes actual, 'put spin on'
    assert_includes actual, 'twirl'
    assert_includes actual, 'spoon'
    assert_includes actual, 'whack up'
  end

  test 'it parses translations for zakład' do
    html = File.read('test/htmls/babla/zakład.html')

    actual = ParseBablaHtml.new.call(html, 'zakład')

    assert_equal 16, actual.size
    assert_includes actual, 'bet'
    assert_includes actual, 'factory'
  end
end
