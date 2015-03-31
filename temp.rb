require './init_db'
require 'nokogiri'
require 'open-uri'
#require 'logger'

#DB.loggers << Logger.new($stdout)

#fetching HTML code
html = Nokogiri::HTML(open('http://www.catalog.onliner.by'))

def create_category(category_node)
url = category_node.xpath("./a[1]/@href").text
name = url.sub("http://catalog.onliner.by/","").delete('/')
name_ru = category_node.xpath("./a[last()]").text
is_new = category_node.xpath("./a[2]/img[@class='img_new']").any?
Category.create({ name: name, name_ru: name_ru, url: url, is_new: is_new })
end
 
def create_group(group_node)
name = group_node.text.delete("0-9")
Group.create({ name_ru: name })
end
 
class Group < Sequel::Model
 # many_to_many :categories
 # one_through_one :category
end
class Category < Sequel::Model
end
class Product < Sequel::Model
end
class GroupCategory < Sequel::Model(:groups_categories)
end
groups = html.xpath("//h1[@class='cm__h1']")
categories_blocks = html.xpath("//ul[@class='b-catalogitems']")
 
groups.zip(categories_blocks).map do |group_node, categories_block|
  group = create_group(group_node)
  categories_block.map do |category_node|
    category = create_category(category_node)
    group.add_category(category)
  end
end 
