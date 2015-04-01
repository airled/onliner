require './init_db'

class Group < Sequel::Model
  many_to_many :categories
end
