class ParseBablaHtml
  def call(html, corrected)
    doc = Nokogiri::HTML(html)
    doc
      .xpath('//*[contains(@class, "babQuickResult") and text() = "' + corrected + '"]')
      .map { |x| x.xpath('../../*[contains(@class, "quick-result-overview")]//a/text()') }
      .flatten
      .map(&:text)
  end
end
