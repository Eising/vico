Sequel.migration do
  change do
    drop_column :configs, :config
    add_column :configs, :up_config, String, :text => true
    add_column :configs, :down_config, String, :text => true
  end
end
