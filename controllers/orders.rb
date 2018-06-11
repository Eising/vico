class Icing < Sinatra::Base
  # @!group Orders controller

  # @method get_index
  # Shows all scheduled orders
  # @note This is the front page

  get '/' do
    @pagename = "orders_index"
    @pagetitle = "All orders"

    @orders = Orders.exclude(:deleted => true).all
    @forms = Forms.exclude(:deleted => true).all
    erb :'orders/orders'
  end

  post '/order/add' do
    # Do something with the submitted
    args = {
      :reference => params[:reference],
      :customer => params[:customer],
      :location => params[:location],
      :product => params[:product],
      :speed => params[:speed].to_i,
      :form_id => params[:form_id],
      :created => Time.now
    }
    order_id = Orders.create(args)
    redirect to("/order/config/#{order_id}")

  end

  get '/order/config/:id' do
    order = Orders.where(:id => params[:id]).first
    p order.form
    p order.form.template
    "hello world"
  end






end
