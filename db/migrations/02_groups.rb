Sequel.migration do
  up do
    create_table :groups do
      primary_key :id
      Integer :category_id, :size=>9
      String :name
      String :name_ru
    end
  end
  down do
    drop_table(:groups)
  end
end   
