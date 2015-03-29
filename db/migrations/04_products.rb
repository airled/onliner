Sequel.migration do
  up do
    create_table :products do
      primary_key :id
      String :url, :size=>512
      String :name
      String :image_url
    end
  end
  down do
    drop_table(:products)
  end
end   
