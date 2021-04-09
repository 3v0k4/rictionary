class Fetch
  def call(query)
    return NoQueryViewModel.new if query.empty?

    html = FetchWiktionaryPage.new.call(query)
    return view_model(query, html) unless html.nil?

    query = query.downcase
    html = FetchWiktionaryPage.new.call(query)
    return view_model(query, html) unless html.nil?

    query = CorrectQueryViaWiktionary.new.call(query.downcase) || query
    html = FetchWiktionaryPage.new.call(query)
    return view_model(query, html) unless html.nil?

    fetched = FetchBablaTranslations.new.call(query)

    if fetched.found?
      FallbackViewModel.new(query: fetched.corrected, translations: fetched.translations)
    else
      NotFoundViewModel.new(query: query)
    end
  end

  private

  def view_model(query, html)
    parsed = ParseWiktionaryHtml.new.call(html)
    fallback_link, translations = fallback_link_and_translations(query, parsed)
    ViewModel.new(
      query: query,
      parse_result: parsed.with_translations(translations),
      fallback_link: fallback_link
    )
  end

  def fallback_link_and_translations(query, parsed)
    return [nil, parsed.translations] if parsed.translations.any?
    fetched = FetchBablaTranslations.new.call(query)
    [fetched.fallback_link, fetched.translations]
  end
end
