class Fetch
  def initialize(http_client: HttpClient.new)
    @http_client = http_client
  end

  def call(query)
    return NoQueryViewModel.new if query.empty?

    q, h = FetchWiktionaryPage.new.call(query)
    return view_model(query, q, h) unless h.nil?

    q, h = FetchWiktionaryPage.new.call(query.downcase)
    return view_model(query, q, h) unless h.nil?

    q, h = FetchWiktionaryPage.new.call(CorrectQueryViaWiktionary.new.call(query.downcase) || query)
    return view_model(query, q, h) unless h.nil?

    q, h = [CorrectQueryViaBabla.new.call(q), nil]

    if q.nil?
      NotFoundViewModel.new(query: query, corrected_query: query)
    else
      fallback_(query, q)
    end
  end

  private

  def fallback_(query, corrected)
    link = "https://pl.bab.la/slownik/polski-angielski/#{corrected}".gsub(' ', '-')
    ts = ParseBablaHtml.new.call(@http_client.get_or(link, ""), corrected)
    FallbackViewModel.new(query: query, corrected_query: corrected, translations: ts)
  end

  def view_model(query, corrected, html)
    parsed = ParseWiktionaryHtml.new.call(html)

    ts, flink =
      if parsed.translations.any?
        [parsed.translations, nil]
      elsif corrected_via_babla = CorrectQueryViaBabla.new.call(corrected)
        [
          fallback_("", corrected_via_babla).translations,
          "https://pl.bab.la/slownik/polski-angielski/#{corrected}",
        ]
      else
        [[], nil]
      end

    ViewModel.new(query: query, corrected_query: corrected, parse_result: parsed.with_translations(ts), fallback_link: flink)
  end
end
