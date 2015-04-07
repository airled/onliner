require './init_db'
require './init_models'
require 'nokogiri'
require 'open-uri'
require 'pry'
#require 'logger'; DB.loggers << Logger.new($stdout)


html_product = Nokogiri::HTML(open('http://catalog.onliner.by/mobile/'))
a=html_product.xpath("//td[@align='right']/strong/a[contains(text(), 'Следующие')]/@href").text
url = if a!= ''
  a
  else
    false
end
puts url
