require 'open-uri'

module TaskHelper
  def self.get_yoga_sutras(url, chapter)
    uri = URI(url)
    page = Nokogiri::HTML(open(uri))

    lines = []
    number = 1
    page.css('div.skt-line a').each do |line|
      if match = line.to_s.match(/<a .*>(.*)<br>(.*)<br>(.*)<\/a>/m)
        devanagari, translit, english = match.captures.map { |capt| capt.strip }
        verse = "#{chapter}.#{number}"
        if verse.size == 3
          verse = verse.gsub('.', '.0')
        end
        puts verse
        link = line['href']

        Sutra.create(
          verse: verse,
          devanagari: devanagari,
          transliteration: translit,
          english: english,
          link: link
        )

        number += 1
      end
    end
  end
end