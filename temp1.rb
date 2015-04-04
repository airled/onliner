require 'sequel'
require 'mysql2'
require 'nokogiri'
require 'open-uri'
require 'logger'

database=Sequel.connect(:adapter=>'mysql2', :host=>'localhost', :user=>'root', :database=>'test')

#database.loggers << Logger.new($stdout)

database.run('drop table if exists prods')

database.create_table :prods do
  primary_key :id
  String :url
  String :name, :size=>20
end

class Prod < Sequel::Model
end

url = 'http://catalog.onliner.by/antivirus/'
url_const = 'http://catalog.onliner.by/'

while url do
  html = Nokogiri::HTML(open(url))
  
  html.xpath("//tr/td[@class='pdescr']").map do |prod_node|
    url = prod_node.xpath("./strong/a/@href")
    name = prod_node.xpath("./strong/a").text.delete("\n").delete(" ")
    aproduct=Prod.create(:url=>url, :name=>name)
  end

  html.xpath("//a").map do |node|
    if node.text.delete("\n").delete(" ") == "Следующие15позиций"
      url = url_const + node.xpath("./@href").to_s
      puts url
    break
    else url = false
    end
  end
end
