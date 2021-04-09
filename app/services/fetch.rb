class Fetch
  def call(query)
    return NoQueryViewModel.new if query.empty?

    q = query
    html = FetchWiktionaryPage.new.call(q)
    return wiktionary_view_model(q, html) unless html.nil?

    q = query.downcase
    html = FetchWiktionaryPage.new.call(q)
    return wiktionary_view_model(q, html) unless html.nil?

    q = CorrectQueryViaWiktionary.new.call(query.downcase)
    if q
      html = FetchWiktionaryPage.new.call(q)
      return wiktionary_view_model(q, html) unless html.nil?
    end

    q = query
    fetched = FetchBablaTranslations.new.call(q)
    return BablaViewModel.new(query: fetched.corrected, translations: fetched.translations) unless fetched.nil?

    NotFoundViewModel.new(query: query)
  end

  private

  def wiktionary_view_model(query, html)
    parsed = ParseWiktionaryHtml.new.call(html)
    babla_url, translations = babla_url_and_translations(query, parsed)
    WiktionaryViewModel.new(
      query: query,
      parse_result: parsed.with_translations(translations),
      babla_url: babla_url
    )
  end

  def babla_url_and_translations(query, parsed)
    return [nil, parsed.translations] if parsed.translations.any?
    fetched = FetchBablaTranslations.new.call(query)
    [fetched.babla_url, fetched.translations]
  end
end
