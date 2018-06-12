class Icing < Sinatra::Base

  get '/dynjs/validators.js' do
    content_type 'text/javascript'

    erb :'dynjs/validators', :layout => false
  end
end
