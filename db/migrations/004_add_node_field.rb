Sequel.migration do
  change do
    add_column :orders, :node, String
  end
end
