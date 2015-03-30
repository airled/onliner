require 'sequel'
require 'mysql2'
require 'yaml'
#require 'logger'

=begin
#connecting to a MySQL database
file = File.open("#{Dir.pwd}/config")
values = []
file.each_line { |line| values.push line.chomp }
file.close
parameters = [:adapter,:user,:password,:host,:database]
connect_parameters = Hash[parameters.zip(values)]
DB = Sequel.connect(connect_parameters)
#DB.loggers << Logger.new($stdout)
=end
