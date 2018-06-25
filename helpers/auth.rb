class Icing < Sinatra::Base

  def hash_password(password)
    BCrypt::Password.create(password).to_s
  end

  def test_password(password, hash)
    BCrypt::Password.new(hash) == password
  end

  def current_user
    if session[:user_id]
      Users.exclude(:deleted => true).where(:id => session[:user_id]).first
    else
      nil
    end
  end

  def authenticate!
    if session[:user_id] and Users.exclude(:deleted => true).where(:id => session[:user_id]).count == 1
      nil
    else
      redirect to('/login')
    end
  end

end
