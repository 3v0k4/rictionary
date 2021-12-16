require 'test_helper'

class ParseBablaHtmlTest < ActiveSupport::TestCase
  test 'it parses translations for podkręcić' do
    html = File.read('test/htmls/babla/podkręcić.html')

    actual = ParseBablaHtml.new.call(html, 'podkręcić')

    assert_equal 8, actual.size
    assert_includes actual, 'to crank up'
    assert_includes actual, 'to overclock'
    assert_includes actual, 'to gun'
    assert_includes actual, 'to pump up'
    assert_includes actual, 'to put spin on'
    assert_includes actual, 'to twirl'
    assert_includes actual, 'to spoon'
    assert_includes actual, 'to whack up'
  end

  test 'it parses translations for zakład' do
    html = File.read('test/htmls/babla/zakład.html')

    actual = ParseBablaHtml.new.call(html, 'zakład')

    assert_equal 16, actual.size
    assert_includes actual, 'bet'
    assert_includes actual, 'factory'
  end
end
