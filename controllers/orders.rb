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
    @products = get_products
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
    template_fields = {}
    params.each do |param, value|
      if res = param.match(/^form\.(.*)$/)
        field = res[1]
        template_fields[field] = value
      end
    end
    args[:template_fields] = template_fields.to_json

    order = Orders.create(args)

    redirect to("/config/render_order/#{order.id}")

  end

  get '/order/dynconfig/:id' do
    form = Forms.where(:id => params[:id]).first

    all_tags = []
    all_fields = {}
    inventory_tags = {}
    form.template.each do |template|
      all_tags = all_tags | get_configurable_tags(template.id)
      all_fields.merge! template.fields
      get_inventory_tags(template.id).each do |inventory, selector|
        if inventory_tags.has_key? inventory
          if inventory_tags[inventory].has_key? selector
            inventory_tags[inventory][selector] = inventory_tags[inventory][selector] | selector
          else
            inventory_tags[inventory][selector] = selector
          end
        else
          inventory_tags[inventory] = selector
        end
      end
    end
    defaults = form.defaults

    @inventory_tags = inventory_tags

    all_tags.each do |tag|
      if defaults.has_key? tag
        defaults[tag][:klass] = config.validators[all_fields[tag]][:class]
      end
    end
    @defaults = defaults

    erb :'orders/dynconfig', :layout => false




  end


end
