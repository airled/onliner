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

#creating products in the Products mysql table
def create_product(product_node)
  url = product_node.xpath("./strong/a/@href")
  name = product_node.xpath("./strong/a").text.delete("\n").delete(" ")
  Product.create(url: url, name: name)
end


groups = html.xpath("//h1[@class='cm__h1']")
categories_blocks = html.xpath("//ul[@class='b-catalogitems']")

groups.zip(categories_blocks).map do |group_node, categories_block|
  group = create_group(group_node)
  categories_block.xpath("./li/div[@class='i']").map do |category_node|
    category = create_category(category_node)
    group.add_category(category)
    
    url_product = category_node.xpath("./a[1]/@href").text
    url_product_const = 'http://catalog.onliner.by/'

    while url_product do

      html_product = Nokogiri::HTML(open(url_product))
      html_product.xpath("//tr/td[@class='pdescr']").map do |product_node|
        product = create_product(product_node)
        category.add_product(product)
      end
      html_product.xpath("//a").map do |is_next_node|
        if is_next_node.text.include?("Следующие" && "позиций")
          url_product = url_product_const + is_next_node.xpath("./@href").to_s
          break
        else url_product = false
        end
      end

    end

  end
end
