require "open-uri"

# This file was ment to run only once.

ActiveRecord::Base.transaction do
  [
    "movie",
    "tv series",
    "tv movie",
    "video movie",
    "tv mini series",
    "video game",
    "episode",
  ].each do |kind|
    KindType.create!(kind: kind)
  end

  page = open("http://www.imdb.com/chart/top")
  content = File.read(page)
  html = Nokogiri::HTML(content)
  html.search("table.chart tbody tr").each do |tr|
    Title.create!(
      title: tr.search("td.titleColumn a text()").to_s,
      production_year: tr.search("td.titleColumn span.secondaryInfo text()").to_s.delete("()"),
      kind_id: 1,
    )
  end
end
