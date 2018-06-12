class Icing < Sinatra::Base

  get '/config' do
    @configs = Configs.all

    erb :'config/index'
  end

  get '/config/render_order/:id' do
    order = Orders.where(:id => params[:id]).first

    # Compile the template

    params = order.template_fields
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



end
