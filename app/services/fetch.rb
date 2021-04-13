class Fetch
  def call(query)
    return NoQueryViewModel.new if query.empty?

    catch(:found) do
      try_wiktionary(query)
      try_wiktionary(query.downcase)
      try_wiktionary_with_correction(query)
      try_babla(query)
      NotFoundViewModel.new(query: query)
    end
  end

  private

  def try_wiktionary(query)
    html = FetchWiktionaryPage.new.call(query)
    return if html.nil?
    throw :found, wiktionary_view_model(query, html)
  end

  def try_wiktionary_with_correction(query)
    q = CorrectQueryViaWiktionary.new.call(query.downcase)
    return if q.nil?
    try_wiktionary(q)
  end

  def try_babla(query)
    fetched = FetchBablaTranslations.new.call(query)
    return if fetched.nil?
    throw :found, BablaViewModel.new(query: fetched.corrected, translations: fetched.translations)
  end

  def wiktionary_view_model(query, html)
    parsed = ParseWiktionaryHtml.new.call(html)
    view_model = WiktionaryViewModel.new(query: query, parse_result: parsed)
    return view_model if parsed.translations.any?
    fetched = FetchBablaTranslations.new.call(query)
    view_model.with_babla_translations(fetched)
  end
end
