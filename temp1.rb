require './init_db'
require './init_models'
require 'nokogiri'
require 'open-uri'
#require 'logger'; DB.loggers << Logger.new($stdout)

#fetching HTML code

file=File.open('/home/air/Desktop/1','w')
url_const = "http://catalog.onliner.by"
html = Nokogiri::HTML(open(url_const))
html.xpath("//h1[@class='cm__h1']").map do |node|
  file.puts node.text
  p node.text
end

file.close
