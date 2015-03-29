require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open('http://www.catalog.onliner.by'))

a=[]
xcategory = "//table[@class='fphotblock add_line_main_menu']//div[@class='i']"
category = page.xpath(xcategory).map do |node|
  url = node.xpath("./a[1]/@href").text
  name = node.xpath("./a[last()]").text
  h={:name=>name, :url=>url}
  a.push h
end
puts a
  
http://catalog.onliner.by/pic/ico-mcat682blue.gif
http://catalog.onliner.by/pic/restyle_3/new.gif
