class Icing < Sinatra::Base

  get '/config' do
    authenticate!
    @pagename = "config_index"
    @pagetitle = "View Configurations"
    @configs = Configs.all

    erb :'config/index'
  end

  get '/config/render_order/:id' do
    authenticate!
    order = Orders.where(:id => params[:id]).first

    # Compile the template

    params = order.template_fields
    # Include the standard fields
    params[:customer] = order.customer
    params[:location] = order.location
    params[:reference] = order.reference
    up_template = []
    down_template = []
    inventory_entries = {}
    p params
    params.each do |param, value|
      if res = param.match(/^inv\.(\d+)\.selector\.(.*)$/)
        inventory_id = res[1]
        row_id = value
        row = Inventories.where(:id => row_id).first
        selector = res[2]
        inventory = Inventories.where(:id => inventory_id).first
        inventory_name = inventory.entries["name"]
        row.entries.each do |entry, val|
          keyname = "inventory__#{inventory_name}__#{entry}__#{selector}"
          p keyname
          inventory_entries[keyname] = val
        end
      end
    end



    order.form.template.each do |template|
      get_inventory_tags_raw(template.id).each do |tag|
        comp_name = tag
        if inventory_entries.has_key? comp_name
          params[tag] = inventory_entries[comp_name]
        end
      end
      up_template << Mustache.render(template.up_contents, params)
      down_template << Mustache.render(template.down_contents, params)
    end

    up_template = up_template.join("\n")
    down_template = down_template.join("\n")

    if Configs.where(:order_id => order.id).count > 0
      # Update the old config
      Configs.where(:order_id => order.id).update(:up_config => up_template, :down_config => down_template, :order_id => order.id, :timestamp => Time.now)
      config = Configs.where(:order_id => order.id).first
    else
        config = Configs.create(:up_config => up_template, :down_config => down_template, :order_id => order.id, :timestamp => Time.now)
    end

    redirect to("/config/view/#{config.id}")
  end

  get '/config/view/:id' do
    authenticate!
    @pagename = "config_view"
    @pagetitle = "View Configuration"
    @config = Configs.where(:id => params[:id]).first


    erb :'config/view'
  end

  get '/config/raw/up/:id' do
    authenticate!
    @config = Configs.where(:id => params[:id]).first

    content_type 'text/plain'
    @config.up_config
  end
  get '/config/raw/down/:id' do
    authenticate!
    @config = Configs.where(:id => params[:id]).first

    content_type 'text/plain'
    @config.down_config
  end

  get '/config/nodes' do
    authenticate!
    @pagename = "config_nodes"
    @pagetitle = "View node conf"
    # Fetch all orders where the node field is set
    @orders = Orders.exclude(:deleted => true).exclude(:node => nil).select(:node).distinct.all

    erb :'/config/nodes'

  end

  get '/config/node/:node' do
    authenticate!
    @pagename = "config_nodeview"
    @pagetitle = params[:node]
    valid_nodes = Orders.exclude(:deleted => true).exclude(:node => nil).select(:node).distinct.all.collect { |n| n.node }

    if not valid_nodes.include? params[:node]
      redirect to('/config/nodes')
    end
    @nodename = params[:node]
    @configs = Orders.exclude(:deleted => true).where(:node => params[:node]).all

    erb :'/config/nodeview'

  end





end
