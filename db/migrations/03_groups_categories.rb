Sequel.migration do
  up do
    create_table :groups_categories do
      primary_key :id
      foreign_key :group_id, key: :id, :groups
      foreign_key :category_id, key: :id, :categories
    end
  end
  down do
    drop_table(:groups_categories)
  end
end   
