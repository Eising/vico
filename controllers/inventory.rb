# WIP
=begin
This module will do some JSON magic.

- Create Inventory:
Inventory.create(:entries => { "name" => "Inventory name", "fields" => { hash with fields and validation } }.to_json)

- Add Inventory row:

Inventory.create(:inventory_id => parent_id, :entries => { hash with fields and values })

- Find a specific inventory:

entries = Sequel.pg_jsonb_op(:entries)
inventory = Inventories.where(entries.get_text('name') => "Name")

- Add a row
inventory.first.add_row(:entries => rowhash.to_json)

- Search for a specific row in an inventory

Inventory.where(inventory_id => Inventories.where(entries.get_text('name') => "Name").get(:id)).where(entries.get_text('field') => "fieldvalue")

=end

class Icing < Sinatra::Base

  get '/inventories' do
    authenticate!
    @pagename = "inventory_index"
    @pagetitle = "Inventories"

    @inventories = Inventories.where(:inventory_id => nil).exclude(:deleted => true).all

    erb :'inventories/inventories'
  end

  get '/inventory/:id' do
    authenticate!
    @pagename = "inventory_view"
    @inventory = Inventories.where(:id => params[:id]).first
    @pagetitle = "Inventory #{@inventory.entries['name']}"
    @columns = @inventory.entries["fields"].keys

    erb :'inventories/view'
  end

  get '/inventories/delete/:id' do
    authenticate!
    inventory = Inventories.where(:id => params['id'])
    if inventory.count == 1
      inventory.update(:deleted => true)
    end

    redirect to('/inventories')
  end

  post '/inventories/row/update' do
    authenticate!
    id = params["pk"]
    inventory = Inventories.where(:id => id)
    entries = inventory.first.entries
    entries[params["name"]] = params["value"]
    inventory.update(:entries => entries.to_json, :user_id => current_user.id)

    {:message => "Sucessfully updated", :params => params}.to_json

  end

  post '/inventories/row/add' do
    authenticate!
    inventory_id = params[:inventory_id]
    inventory = Inventories.where(:id => inventory_id).first
    entries = {}
    params.each do |key, value|
      if res = key.match(/^key\.(.*)$/)
        entries[res[1]] = value
      end
    end
    user_id = current_user.id
    inventory.add_row(:entries => entries.to_json, :user_id => user_id)

    redirect to("/inventory/#{inventory_id}")


  end

  get '/inventories/row/delete/:id' do
    authenticate!

    inventory = Inventories.where(:id => params[:id])
    if inventory.count == 1
      parent_id = inventory.first.inventory_id
      inventory.delete
    end

    redirect to("/inventory/#{parent_id}")

  end


  get '/inventories/add' do
    authenticate!
    @pagename = "inventory_add"
    @pagetitle = "Add Inventory"
    @validators = config.validators

    erb :'/inventories/add'

  end

  post '/inventories/add' do
    authenticate!

    name = params["name"]
    fields = {}

    params.each do |key, value|
      if res = key.match(/^field\.(.*)$/)
        fields[res[1]] = value
      end
    end

    entries = {
      "name" => name,
      "fields" =>  fields
    }

    Inventories.create(:entries => entries.to_json, :user_id => current_user.id)

    redirect to('/inventories')

  end

  # Generate an excel template for import/export
  get '/inventories/generate_template/:id' do
    authenticate!
    content_type :'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    attachment("import.xlsx")
    inventory_id = params[:id]
    data = generate_xl_template(inventory_id)
    data

  end

  get '/inventories/upload/:id' do
    authenticate!
    @pagename = "inventories_upload"
    @pagetitle = "Import (XLSX)"
    @inventory_id = params[:id]

    erb :'/inventories/upload'
  end

  post '/inventories/upload' do
    authenticate!
    file = params[:uploadsheet][:tempfile]
    parse_xl_template(file.read, params[:inventory_id])

    redirect to("/inventory/#{params[:inventory_id]}")


  end

  get '/inventories/import/:id' do
    authenticate!
    @pagename = "inventory_import"
    @pagetitle = "Bulk Inventory"

    erb :'inventories/import'

  end

  get '/api/v1/inventories' do

  end
end
