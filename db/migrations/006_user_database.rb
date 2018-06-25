Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      String :name
      String :realname
      String :email
      Integer :access_level, :default => 10
      String :password
      TrueClass :deleted, :default => false
    end
    add_column :inventories, :user_id, Integer
  end
end
