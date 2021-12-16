class ParseBablaHtml
  def call(html, corrected)
    Nokogiri::HTML(html)
      .xpath('//*[contains(@class, "babQuickResult") and text() = "' + corrected + '"]')
      .map { |x| x.xpath('../../*[contains(@class, "quick-result-overview")]//a/text()') }
      .flatten
      .map(&:text)
      .select { _1.strip.present? }
  end
end
