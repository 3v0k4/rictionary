class Language < ApplicationRecord
  DEFAULT = ['🇵🇱', 'polish']
  # https://meta.wikimedia.org/wiki/Wiktionary#List_of_Wiktionaries
  LANGUAGES = [
    ['🇦🇲', 'armenian'],
    ['🇲🇲', 'burmese'],
    ['🇦🇩', 'catalan'],
    ['🏳', 'cherokee'],
    ['🇨🇳', 'chinese'],
    ['🇨🇿', 'czech'],
    ['🇳🇱', 'dutch'],
    ['🇺🇸', 'english'],
    ['🏳', 'esperanto'],
    ['🇪🇪', 'estonian'],
    ['🇫🇮', 'finnish'],
    ['🇫🇷', 'french'],
    ['🇩🇪', 'german'],
    ['🇬🇷', 'greek'],
    ['🇮🇳', 'hindi'],
    ['🇭🇺', 'hungarian'],
    ['🏳', 'ido'],
    ['🇮🇩', 'indonesian'],
    ['🇮🇹', 'italian'],
    ['🇯🇵', 'japanese'],
    ['🏳', 'kannada'],
    ['🇰🇷', 'korean'],
    ['🏳', 'kurdish'],
    ['🏳', 'limburgish'],
    ['🇱🇹', 'lithuanian'],
    ['🇲🇬', 'malagasy'],
    ['🏳', 'malayalam'],
    ['🇳🇴', 'norwegian'],
    ['🏳', 'oriya'],
    ['🇮🇷', 'persian'],
    DEFAULT,
    ['🇵🇹', 'portuguese'],
    ['🇷🇴', 'romanian'],
    ['🇷🇺', 'russian'],
    ['🇷🇸', 'serbian'],
    ['🇭🇷', 'serbo-croatian'],
    ['🇪🇸', 'spanish'],
    ['🇸🇪', 'swedish'],
    ['🏳', 'tamil'],
    ['🏳', 'telugu'],
    ['🇹🇭', 'thai'],
    ['🇹🇷', 'turkish'],
    ['🇺🇿', 'uzbek'],
    ['🇻🇳', 'vietnamese'],
  ]

  def self.options
    LANGUAGES.map { |flag, language| ["#{flag} #{language.capitalize}", language] }
  end

  def self.default
    DEFAULT.last
  end
end
