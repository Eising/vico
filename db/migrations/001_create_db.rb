Sequel.migration do
  up do
    create_table :templates do
      primary_key :id
      String :up_contents, :text => true
      String :down_contents, :text => true
      String :name
      String :description
      column :fields, :jsonb
      String :platform
      Integer :user_id
      TrueClass :deleted, :defaults => false
      DateTime :created
      DateTime :modified

    end

    create_table :forms do
      primary_key :id
      String :name
      column :defaults, :jsonb
      String :description
      TrueClass :require_update, :defaults => false
      DateTime :created
      DateTime :modified
      Integer :user_id
      TrueClass :deleted, :defaults => false
    end

    create_table :forms_templates do
      foreign_key :template_id, :templates, key: :id
      foreign_key :form_id, :forms, key: :id
      primary_key [:template_id, :form_id]
    end

    create_table :orders do
      primary_key :id
      String :reference
      String :customer
      String :location
      Fixnum :speed
      String :product
      String :comment
      Integer :form_id
      column :template_fields, :jsonb
      TrueClass :completed, :defaults => false
      TrueClass :deleted, :defaults => false
      DateTime :created
      Date :deadline
      Integer :user_id
    end

    create_table :configs do
      primary_key :id
      String :config, :text => true
      Integer :order_id
      DateTime :timestamp
    end
  end
  down do
    drop_table :templates_forms
    drop_table :templates
    drop_table :forms
    drop_table :orders
    drop_table :configs
  end
end
