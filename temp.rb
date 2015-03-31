require './init_db'
require 'nokogiri'
require 'open-uri'
#require 'logger'

#DB.loggers << Logger.new($stdout)

#fetching HTML code
html = Nokogiri::HTML(open('http://www.catalog.onliner.by'))

#GROUPS
#collecting group names in an array
xgroups = "//h1[@class='cm__h1']"
groups = html.xpath(xgroups).map{ |node| node.text.delete("0-9") }

#CATEGORIES
#collecting category URLs in an array
xcategories = "//table[@class='fphotblock add_line_main_menu']//div[@class='i']"
categories = html.xpath(xcategories).map do |node|
  url = node.xpath("./a[1]/@href").text
  name_ru = node.xpath("./a[last()]").text
  is_new = node.xpath("./a[2]/img[@class='img_new']").any?
 # {:name_ru=>name_ru, :url=>url, :is_new=>is_new}
end

p categories
