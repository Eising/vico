class Icing < Sinatra::Base

  get '/login' do
    @pagename = "login_login"
    @pagetitle = "Login"

    erb :'auth/login', :layout => false
  end


  post '/login' do
    username = params[:username]
    user = Users.exclude(:deleted => true).where(:name => username)
    if user.count == 1 and test_password(params[:password], user.get(:password))
      session.clear
      session[:user_id] = user.get(:id)
      redirect('/')
    else
      @error = "Username or password incorrect"
      erb :'auth/login', :layout => false
    end
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end
end
