class Icing < Sinatra::Base
  def get_products
    products = Orders.exclude(:deleted => true).exclude(:product => nil).exclude(:product => "").select(:product).distinct.all.collect { |n| n.product }

    products
  end

  def unique_reference? reference
    if config.base["enforce_unique_references"]
      if Orders.exclude(:deleted => true).where(:reference => reference).count > 0
        return false
      else
        return true
      end
    else
      return true
    end
  end
end
