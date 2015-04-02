require './init_db'
require './init_models'
require 'nokogiri'
require 'open-uri'
require 'curb'
require 'logger'
#DB.loggers << Logger.new($stdout)

html0 = Nokogiri::HTML(open('http://catalog.onliner.by'))
html1 = Curl.get('http://catalog.onliner.by').body

file0=File.open('/home/air/Desktop/0','w')
file1=File.open('/home/air/Desktop/1','w')
file0.puts html0
file1.puts html1
file0.close
file1.close
