require 'rubygems'
require 'nokogiri'
require 'open-uri'

# TODO
# debug leading/trailing spacing
# bring in poem of day

page = Nokogiri::HTML(open('http://www.poetryfoundation.org/widget/single_random_poem'))
CONTENT = {
  of_day: 0,
  random: 0
}

# random poem
widg = page.at_css('div.widget-content').at_css('div.single')

title =  widg.css('.title')[0].text
author = widg.css('.sub')[0].text.sub(/^by /i, '')
lines = widg.css('div').map{ |line| line.text.split.join(" ") }
# line.text.sub(/\A[[:space]]+|[[:space:]]+\z/, '') }

puts("\n#{title}\nby  #{author}\n\n")

lines.each{ |l| puts(l) }
