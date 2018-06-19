class Icing < Sinatra::Base
  def get_products
    products = Orders.exclude(:deleted => true).exclude(:product => nil).exclude(:product => "").select(:product).distinct.all.collect { |n| n.product }

    products
  end
end
