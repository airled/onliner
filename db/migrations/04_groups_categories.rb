Sequel.migration do
  up do
    create_table :groups_categories do
      primary_key :group_id
      primary_key :category_id
    end
  end
  down do
    drop_table(:groups_categories)
  end
end   
