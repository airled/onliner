require 'nokogiri'
require 'open-uri'

#fetching HTML code
page = Nokogiri::HTML(open('http://www.catalog.onliner.by'))

#collecting category URLs in an array
a=[]
xcategory = "//table[@class='fphotblock add_line_main_menu']//div[@class='i']"
category = page.xpath(xcategory).map do |node|
  url = node.xpath("./a[1]/@href").text
  name = node.xpath("./a[last()]").text
  
http://catalog.onliner.by/pic/ico-mcat682blue.gif
http://catalog.onliner.by/pic/restyle_3/new.gif

  h={:name=>name, :url=>url}
  a.push h
end
puts a
=begin
xcategory_urls = "//table[@class='fphotblock add_line_main_menu']//div/a[1]/@href"
category_urls = page.xpath(xcategory_urls).map{ |link| link.value }.uniq
=end
