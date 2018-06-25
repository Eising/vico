Sequel::Model.plugin :xml_serializer
Sequel::Model.plugin :json_serializer

class Templates < Sequel::Model
  many_to_many :form, :class => :Forms, :right_key => :form_id, :left_key => :template_id
end

class Forms < Sequel::Model
  many_to_many :template, :class => :Templates, :right_key => :template_id, :left_key => :form_id
  many_to_one :order_form, :class => :Orders, :key => :form_id
end

class Orders < Sequel::Model
  many_to_one :form, :class => :Forms
  one_to_many :order_config, :class => :Configs, :key => :order_id
end

class Configs < Sequel::Model
  many_to_one :order, :class => :Orders
end

class Inventories < Sequel::Model
  many_to_one :inventory, class: self
  one_to_many :rows, key: :inventory_id, class: self
end

class Users < Sequel::Model

end
