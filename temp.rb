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
