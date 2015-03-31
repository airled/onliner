Sequel.migration do
  up do
    create_table :categories_groups do
      primary_key :id
      Integer :group_id
      Integer :category_id
    end
  end
  down do
    drop_table(:categories_groups)
  end
end   
