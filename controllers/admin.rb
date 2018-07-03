class Icing < Sinatra::Base

  namespace '/admin' do

    #@!group Admin controller

    # @macro [attach] sinatra.get
    #   @overload get "$1"
    # @method get_admin
    # Shows admin page
    get '/' do
      authenticate!
      @pagename = "admin"
      @pagetitle = "Administration"
      erb :'admin/index'
    end

    get '/orders' do
      authenticate!
      protection_level 100
      @pagename = "admin_orders"
      @pagetitle = "Provisioning orders"
      @orders = Orders.exclude(:deleted => true).all
      @deleted_orders = Orders.where(:deleted => true).all

      erb :'admin/orders'

    end

    get '/order_delete/:id' do
      authenticate!
      protection_level 100
      order = Orders.where(:id => params[:id]).exclude(:deleted => true)
      if order.count == 1
        order.update(:deleted => true)
      end
      redirect to('/admin/orders')
    end

    get '/order_undelete/:id' do
      authenticate!
      order = Orders.where(:id => params[:id], :deleted => true)
      if order.count == 1
        order.update(:deleted => false)
      end
      redirect to('/admin/orders')
    end

    get '/users' do
      authenticate!
      protection_level 100

      @pagename = "admin_users"
      @pagetitle = "Manage users"

      @users = Users.exclude(:deleted => true).all

      erb :'/admin/users'
    end

    get '/user/delete/:id' do
      authenticate!
      protection_level 100

      if Users.where(:id => params[:id]).count == 1
        Users.where(:id => params[:id]).update(:deleted => true)
        redirect to('/admin/users')
      else
        halt 404
      end

    end

    post '/user/add' do
      authenticate!
      protection_level 100
      username = params[:username]
      password = hash_password(params[:password])
      access_level = params[:access_level].to_i
      realname = params[:realname]
      email = params[:email]

      Users.create(:name => username, :realname => realname, :password => password, :email => email, :access_level => access_level)

      redirect to("/admin/users")

    end


  end

end
