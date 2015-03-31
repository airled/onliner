
require './init_db'
require 'nokogiri'
require 'open-uri'
#require 'logger'

#DB.loggers << Logger.new($stdout)

#fetching HTML code
html = Nokogiri::HTML(open('http://www.catalog.onliner.by'))

dataset=DB[:groups_categories]
a=[]
gcount=1
ccount=1
html.xpath("//ul[@class='b-catalogitems']").map do |group_node|
    group_node.xpath("./li").map do |cat_node|
      a.push [:gcount=>gcount,:ccount=>ccount]
      dataset.insert(:group_id=>gcount,:category_id=>ccount)
      ccount+=1
    end
gcount+=1
end
puts a
=begin
#CATEGORIES
#collecting category URLs in an array
xcategories = "//table[@class='fphotblock add_line_main_menu']//div[@class='i']"
categories = html.xpath(xcategories).map do |node|
  url = node.xpath("./a[1]/@href").text
  name = url.sub("http://catalog.onliner.by/","").delete('/')
  name_ru = node.xpath("./a[last()]").text
  is_new = node.xpath("./a[2]/img[@class='img_new']").any?
  {:name=>name, :name_ru=>name_ru, :url=>url, :is_new=>is_new}
end

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
=end
