# WIP
class Icing < Sinatra::Base

  get '/inventories' do

    @inventories = Inventories.exclude(:deleted => true).all

    erb :'inventories/inventories'
  end

  get '/inventory/:id' do
    @inventory = Inventories.where(:id => params[:id]).first

    erb :'inventory/view'
  end

  # JavaScript magic: https://github.com/lightswitch05/table-to-json

  post '/inventories/row/add' do


  end
end
