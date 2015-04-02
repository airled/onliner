require './init_db'

class Product < Sequel::Model
  many_to_many :categories
end
