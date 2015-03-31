Sequel.migration do
  up do
    create_table :groups_categories do
      primary_key :id
      Integer :group_id
      Integer :category_id
    end
  end
  down do
    drop_table(:groups_categories)
  end
end   
