require './init_db'

class Category < Sequel::Model
  many_to_many :groups
  many_to_many :products
end
