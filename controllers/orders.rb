class Icing < Sinatra::Base
  # @!group Orders controller

  # @method get_index
  # Shows all scheduled orders
  # @note This is the front page

  get '/' do
    @pagename = "orders_index"
    @pagetitle = "Provision Service"

    @orders = Orders.exclude(:deleted => true).all
    @forms = Forms.exclude(:deleted => true).all
    erb :'orders/orders'
  end

  post '/order/add' do
    @pagetitle = "Provision Service"
    # Do something with the submitted
    args = {
      :reference => params[:reference],
      :node => params[:node],
      :customer => params[:customer],
      :location => params[:location],
      :product => params[:product],
      :speed => params[:speed].to_i,
      :form_id => params[:form_id],
      :created => Time.now
    }
    order_id = Orders.create(args)
    redirect to("/order/config/#{order_id.id}")

  end

  get '/order/config/:id' do
    @pagename = "orders_config"
    @pagetitle = "Provision Service"
    order = Orders.where(:id => params[:id]).first
    all_tags = []
    all_fields = {}
    order.form.template.each do |template|
      all_tags = all_tags | get_configurable_tags(template.id)
      all_fields.merge! template.fields
    end
    defaults = order.form.defaults
    all_tags.each do |tag|
      if defaults.has_key? tag
        defaults[tag][:klass] = config.validators[all_fields[tag]][:class]
      end
    end
    @defaults = defaults
    @order = order

    erb :"orders/config"

  end

  post '/order/config/save' do
    order = Orders.where(:id => params[:order_id])
    template_fields = {}
    params.each do |param, value|
      next if param == "order_id"
      template_fields[param] = value
    end

    order.update(:template_fields => template_fields.to_json)

    redirect to("/config/render_order/#{params[:order_id]}")
  end

end
