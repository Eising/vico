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


  get '/noaccess' do
    @pagetitle = "Access Denied"

    erb :'auth/noaccess'
  end

  get '/password' do
    authenticate!
    @pagetitle = "Change Password"
    @pagename = "auth_passwd"
    @error = session[:error]
    session[:error] = nil

    erb :'auth/password'
  end

  post '/password' do
    authenticate!
    current_password = params[:curr_password]
    new_password = params[:password]

    if test_password(current_password, current_user.password)
      Users.where(:id => current_user.id).update(:password => hash_password(new_password))
      session.clear
      erb :'auth/login', :layout => false
    else
      session[:error] = "Wrong password. Please try again."
      redirect to('/password')
    end

  end


end
