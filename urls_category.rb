#fetching category URLs from the page and collecting them in a MySQL table
require 'sequel'
require 'mysql2'
require 'nokogiri'
require 'open-uri'
#fetching the HTML code
doc = Nokogiri::HTML(open('http://www.catalog.onliner.by'))
#collecting URLs in an array
xrequest="//table[@class='fphotblock add_line_main_menu']//div/a[1]/@href"
urls = doc.xpath(xrequest).map{ |link| link.value }.uniq
#connecting to a MySQL database
DB=Sequel.connect(:adapter=>'mysql2', :user=>'root', :host=>'localhost', :database=>'test')
#creating model
class Url < Sequel::Model
end
#inserting the URLs into the MySQL table
urls.map { |url| Url.create(:url=>url) }