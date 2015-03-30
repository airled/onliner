require "yaml"
require "sequel"
require "mysql2"

#connecting to a MySQL database
hash = YAML.load_file("./config/database.yml")
DB = Sequel.connect(hash)
