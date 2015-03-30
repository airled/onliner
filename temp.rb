require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open('http://www.catalog.onliner.by'))
page_file=File.open('/home/air/Desktop/1.txt','w')
page_file.puts page

xcategory = "//table[@class='fphotblock add_line_main_menu']//div[@class='i']"
category = page.xpath(xcategory).map do |node|
  url = node.xpath("./a[1]/@href").text
  name = node.xpath("./a[last()]").text
  {:name=>name, :url=>url}
end

puts category
