Sequel.migration do
  up do
    create_table :categories_products do
      primary_key :id
      Integer :product_id
      Integer :category_id
    end
  end
  down do
    drop_table(:categories_products)
  end
end   
