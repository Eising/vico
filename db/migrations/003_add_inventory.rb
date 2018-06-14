Sequel.migration do
  change do
    create_table :inventories do
      primary_key :id
      String :name
      column :fields, :jsonb
      column :entries, :jsonb
      TrueClass :deleted, :defaults => false
    end
  end
end
