require './init_db'
require './init_models'
require 'nokogiri'
require 'open-uri'
require 'logger'
#DB.loggers << Logger.new($stdout)

#fetching HTML code
html = Nokogiri::HTML(open('http://www.catalog.onliner.by'))
 
#creating groups in the Groups mysql table
def create_group(group_node)
  name = group_node.text.delete("0-9")
  Group.create({ name_ru: name })
end

#creating categories in the Categories mysql table
def create_category(category_node)
  url = category_node.xpath("./a[1]/@href").text
  name = url.sub("http://catalog.onliner.by/","").delete('/')
  name_ru = category_node.xpath("./a[last()]").text
  is_new = category_node.xpath("./a[2]/img[@class='img_new']").any?
  Category.create(name: name, name_ru: name_ru, url: url, is_new: is_new)
end

groups = html.xpath("//h1[@class='cm__h1']")
categories_blocks = html.xpath("//ul[@class='b-catalogitems']")

urls_categories=[]
groups.zip(categories_blocks).map do |group_node, categories_block|
  group = create_group(group_node)
  categories_block.xpath("./li/div[@class='i']").map do |category_node|
    category = create_category(category_node)
    group.add_category(category)
    urls_categories.push (category_node.xpath("./a[1]/@href").text)#
  end
end 

#Category.map { |line| puts line }
urls_categories.map do |url|
  html_product = Nokogiri::HTML(open(url))
  html_product.xpath("//tr/td[@class='pdescr']").map do |node|
    url = node.xpath("./strong/a/@href")
    name = node.xpath("./strong/a").text.delete("\n")
    aproduct=Product.create(:url=>url, :name=>name)
    Category.add_product(aproduct)
  end
end
