class Icing < Sinatra::Base
  #@!group Admin controller

  # @macro [attach] sinatra.get
  #   @overload get "$1"
  # @method get_admin
  # Shows admin page
  get '/admin' do
    authenticate!
    @pagename = "admin"
    @pagetitle = "Administration"
    erb :'admin/index'
  end

  get '/admin/orders' do
    authenticate!
    protection_level 100
    @pagename = "admin_orders"
    @pagetitle = "Provisioning orders"
    @orders = Orders.exclude(:deleted => true).all
    @deleted_orders = Orders.where(:deleted => true).all

    erb :'admin/orders'

  end

  get '/admin/order_delete/:id' do
    authenticate!
    order = Orders.where(:id => params[:id]).exclude(:deleted => true)
    if order.count == 1
      order.update(:deleted => true)
    end
    redirect to('/admin/orders')
  end

  get '/admin/order_undelete/:id' do
    authenticate!
    order = Orders.where(:id => params[:id], :deleted => true)
    if order.count == 1
      order.update(:deleted => false)
    end
    redirect to('/admin/orders')
  end



end
