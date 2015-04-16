#Onliner's catalog parser. Fetches groups of categories, categories
#and products of each category and inserts them all
#into the appropriate MySQL table.
require './init_models'
require 'nokogiri'
require 'open-uri'
require 'singleton'
#require 'pry'
#require 'logger'; DB.loggers << Logger.new($stdout)

class Parser
  include Singleton

  #Onliner parser works with onliner only ;)
  Url = "http://catalog.onliner.by"
  
  def self.run
    new.run
  end

  #parser's work script
  def run
    start_time=Time.new
    #fetching HTML code
    puts "Fetching start page HTML..."
    html = Nokogiri::HTML(open(Url))
    puts 'Fetched.'
    #fetching groups and categories root nodes
    groups = html.xpath("//h1[@class='cm__h1']")
    categories_blocks = html.xpath("//ul[@class='b-catalogitems']")
    puts 'Parsing...'
    #matching products to their categories and categories to their groups
    groups.zip(categories_blocks).map do |group_node, categories_block|
      group = create_group(group_node)
      categories_block.xpath("./li/div[@class='i']").map do |category_node|
        category = create_category(category_node)
        group.add_category(category)
        create_category_products(category,category_node)
      end
    end
    stop_time=Time.new
    results(stop_time,start_time)
  end

  private

  #creating groups in Groups table
  def create_group(group_node)
    name = group_node.text.delete("0-9")
    Group.create(name_ru: name)
  end

  #creating categories in Categories table
  def create_category(category_node)
    url = category_node.xpath("./a[1]/@href").text
    name = url.sub(Url,"").delete('/')
    name_ru = category_node.xpath("./a[last()]").text
    is_new = category_node.xpath("./a[2]/img[@class='img_new']").any?
    Category.create(name: name, name_ru: name_ru, url: url, is_new: is_new)
  end

  #creating products in Products table
  def create_product(product_node)
    url = Url + product_node.xpath("./strong/a/@href").text
    name = product_node.xpath("./strong/a").text.delete("\n" " ")
    image_url = product_node.xpath("../td[@class='pimage']/a/img/@src").text
    Product.create(url: url, name: name, image_url: image_url)
  end

  #checking if there is a next product page in the same category
  def check_next(products_page)
    xnext = "//td[@align='right']/strong/a[contains(text(), 'Следующие')]/@href"
    next_url = products_page.xpath(xnext).text
    next_products_page_url = if next_url != ''
      Url + "/" + next_url
    else
      false
    end
    next_products_page_url
  end

  #creating all products of a category
  def create_category_products(category,category_node)
    products_page_url = category_node.xpath("./a[1]/@href").text
    while products_page_url
      html_product = Nokogiri::HTML(open(products_page_url))
      html_product.xpath("//tr/td[@class='pdescr']").map do |product_node|
        product = create_product(product_node)
        category.add_product(product)
      end
      products_page_url = check_next(html_product)
    end
  end
  
  #calculating parsing time and amount of fetched objects
  def results(stop,start)
    hours = stop.hour - start.hour
    if stop.min - start.min > 0
      mins = stop.min - start.min
    else
      mins = stop.min - start.min + 60
      hours = hours - 1
    end
    if stop.sec - start.sec > 0
      secs = stop.sec - start.sec
    else
      secs = stop.sec - start.sec + 60
      mins = mins - 1
    end
    puts "Done in #{hours}:#{mins}:#{secs}"
    puts "Got: #{Group.count} groups, #{Category.count} categories, #{Product.count} products"
  end
 
end

Parser.run
