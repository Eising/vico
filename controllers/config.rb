class Icing < Sinatra::Base

  get '/config' do
    @pagename = "config_index"
    @pagetitle = "View Configurations"
    @configs = Configs.all

    erb :'config/index'
  end

  get '/config/render_order/:id' do
    order = Orders.where(:id => params[:id]).first

    # Compile the template

    params = order.template_fields
    # Include the standard fields
    params[:customer] = order.customer
    params[:location] = order.location
    params[:reference] = order.reference
    up_template = []
    down_template = []
    order.form.template.each do |template|
      up_template << Mustache.render(template.up_contents, params)
      down_template << Mustache.render(template.down_contents, params)
    end

    up_template = up_template.join("\n")
    down_template = down_template.join("\n")

    config = Configs.create(:up_config => up_template, :down_config => down_template, :order_id => order.id, :timestamp => Time.now)

    redirect to("/config/view/#{config.id}")
  end

  get '/config/view/:id' do
    @pagename = "config_view"
    @pagetitle = "View Configuration"
    @config = Configs.where(:id => params[:id]).first


    erb :'config/view'
  end

  get '/config/raw/up/:id' do
    @config = Configs.where(:id => params[:id]).first

    content_type 'text/plain'
    @config.up_config
  end
  get '/config/raw/down/:id' do
    @config = Configs.where(:id => params[:id]).first

    content_type 'text/plain'
    @config.down_config
  end

  get '/config/nodes' do
    @pagename = "config_nodes"
    @pagetitle = "View node conf"
    # Fetch all orders where the node field is set
    @orders = Orders.exclude(:deleted => true).exclude(:node => nil).select(:node).distinct.all

    erb :'/config/nodes'

  end

  get '/config/node/:node' do
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
