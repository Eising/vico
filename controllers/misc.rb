class Icing < Sinatra::Base

  get '/license' do

    @pagetitle = "License"

    erb :license

  end
end
