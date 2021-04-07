class Fetch
  def initialize(http_client: HttpClient.new)
    @http_client = http_client
  end

  def call(query)
    return NoQueryViewModel.new if query.empty?

    q, h = try(query)
    return view_model(query, q, h) unless h.nil?

    q, h = try(query.downcase)
    return view_model(query, q, h) unless h.nil?

    q, h = try(CorrectQueryViaWiktionary.new.call(query.downcase) || query)
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
    if parsed.translations.any?
      ViewModel.new(query: query, corrected_query: corrected, parse_result: parsed, fallback_link: nil)
    else
      corrected_via_babla = CorrectQueryViaBabla.new.call(corrected)
      if corrected_via_babla
        flink = "https://pl.bab.la/slownik/polski-angielski/#{corrected}"
        ts = fallback_("", corrected_via_babla).translations
        ViewModel.new(query: query, corrected_query: corrected, parse_result: parsed.with_translations(ts), fallback_link: flink)
      else
        ts = []
        ViewModel.new(query: query, corrected_query: corrected, parse_result: parsed.with_translations(ts), fallback_link: flink)
      end
    end
  end

  def try(query)
    q = query.gsub(" ", "_")
    [query, polish_or_other_langs_or_nil(html(q))]
  end

  def polish_or_other_langs_or_nil(h)
    if h.force_encoding(Encoding::UTF_8).downcase.include?("język polski")
      h
    elsif h.force_encoding(Encoding::UTF_8).downcase.include?("język")
      h
    else
      nil
    end
  end

  def html(query)
    uri_builder = ->(query) { "https://pl.wiktionary.org/api/rest_v1/page/html/#{query}" }
    @http_client.get_or_redirect(uri_builder, query, "")
  end
end
