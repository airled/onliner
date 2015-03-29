require 'sequel'
require 'mysql2'
require 'nokogiri'
require 'open-uri'

#fetching HTML code
html = Nokogiri::HTML(open('http://www.catalog.onliner.by'))

#GROUPS
#collecting group names in an array
xgroup_names_ru = "//h1[@class='cm__h1']"
group_names_ru = html.xpath(xgroup_names_ru).map{ |name| name.text.delete("0-9") }

#CATEGORIES
#collecting category URLs in an array
xcategory_urls = "//table[@class='fphotblock add_line_main_menu']//div/a[1]/@href"
category_urls = html.xpath(xcategory_urls).map{ |link| link.value }.uniq

#connecting to a MySQL database
file = File.open("#{Dir.pwd}/config")
values = []
file.each_line { |line| values.push line.chomp }
file.close
parameters = [:adapter,:user,:password,:host,:database]
connect_parameters = Hash[parameters.zip(values)]
DB = Sequel.connect(connect_parameters)

#creating a model
class Group < Sequel::Model
end
class Category < Sequel::Model
end
class Product < Sequel::Model
end

group_names_ru.map { |name| Group.create(:name_ru => name) }

#inserting the URLs into the MySQL table
category_urls.map { |url| Category.create(:url => url) }
