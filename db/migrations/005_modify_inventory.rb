Sequel.migration do
  change do
    drop_column :inventories, :fields
    add_column :inventories, :inventory_id, Integer
  end
end
