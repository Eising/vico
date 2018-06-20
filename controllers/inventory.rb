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

    @inventories = Inventories.where(:inventory_id => nil).exclude(:deleted => true)

    erb :'inventories/inventories'
  end

  get '/inventory/:id' do
    @pagename = "inventory_view"
    @inventory = Inventories.where(:id => params[:id]).first
    @pagetitle = "Inventory #{@inventory.entries['name']}"
    @columns = @inventory.entries["fields"].keys

    erb :'inventories/view'
  end

  # JavaScript magic: https://github.com/lightswitch05/table-to-json

  post '/inventories/row/update' do
    id = params["pk"]
    inventory = Inventories.where(:id => id)
    entries = inventory.first.entries
    entries[params["name"]] = params["value"]
    inventory.update(:entries => entries.to_json)

    {:message => "Sucessfully updated", :params => params}.to_json

  end

  post '/inventories/row/add' do
    inventory_id = params[:inventory_id]
    inventory = Inventories.where(:id => inventory_id).first
    entries = {}
    p params
    params.each do |key, value|
      if res = key.match(/^key\.(.*)$/)
        entries[res[1]] = value
      end
    end
    p entries
    inventory.add_row(:entries => entries.to_json)

    redirect to("/inventory/#{inventory_id}")


  end

  get '/inventories/row/delete/:id' do

    inventory = Inventories.where(:id => params[:id])
    if inventory.count == 1
      parent_id = inventory.first.inventory_id
      inventory.delete
    end

    redirect to("/inventory/#{parent_id}")

  end


  get '/inventories/add' do
    @pagename = "inventory_add"
    @pagetitle = "Add Inventory"

    erb :'/inventories/add'

  end
end
