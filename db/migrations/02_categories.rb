Sequel.migration do
  up do
    create_table :categories do
      primary_key :id
      String :url, :size=>512
      String :name
      String :name_ru
      TrueClass :is_new
      #default_character_set utf8
    end
  end
  down do
    drop_table(:categories)
  end
end		
