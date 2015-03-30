require 'sequel'
require 'mysql2'
require 'nokogiri'
require 'open-uri'
require 'yaml'
#require 'logger'

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
  name = node.xpath("./a[last()]").text
  is_new = node.xpath("./a[2]/img[@class='img_new']").any?
  {:name=>name, :url=>url, :is_new=>is_new}
end
=begin
#connecting to a MySQL database
file = File.open("#{Dir.pwd}/config")
values = []
file.each_line { |line| values.push line.chomp }
file.close
parameters = [:adapter,:user,:password,:host,:database]
connect_parameters = Hash[parameters.zip(values)]
DB = Sequel.connect(connect_parameters)
#DB.loggers << Logger.new($stdout)
=end
hash = YAML.load_file('database.yml')
DB = Sequel.connect(hash)
#creating a model
class Group < Sequel::Model
  many_to_many :categories
  one_through_one :category
end
class Category < Sequel::Model
end
class Product < Sequel::Model
end

#inserting names of the groups
groups.map { |name| Group.create(:name_ru => name) }

#inserting category values
categories.map { |hash| Category.create(hash) }
