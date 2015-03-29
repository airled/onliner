#fetching category URLs from the page and collecting them in a MySQL table
require 'sequel'
require 'mysql2'
require 'nokogiri'
require 'open-uri'

#fetching HTML code
page = Nokogiri::HTML(open('http://www.catalog.onliner.by'))

#collecting URLs in an array
xgroups = "//"
group_names = page.xpath(xgroups).map{ |link| link.value }.uniq
xrequest = "//table[@class='fphotblock add_line_main_menu']//div/a[1]/@href"
urls = page.xpath(xrequest).map{ |link| link.value }.uniq

#connecting to a MySQL database
file = File.open('')
values = []
file.each_line { |line| values.push line.chomp }
parameters = [:adapter,:user,:password,:host,:database]
connect_parameters = parameters.zip(values).to_h
DB = Sequel.connect(connect_parameters)

#creating a model
class Url < Sequel::Model
end

#inserting the URLs into the MySQL table
urls.map { |url| Url.create(:url => url) }
