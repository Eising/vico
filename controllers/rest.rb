class Icing < Sinatra::Base

  # @!group REST API

  namespace '/api/v1' do

    get '/config' do
      content_type 'text/json'
      reference = nil
      if params.has_key? :reference
        # We filter by reference
        reference = params[:reference]
      end

      if reference
        # Filter on reference
        orders = Orders.where(:reference => reference).all
      else
        orders = Orders.all
      end

      data = []
      orders.each do |order|
        order.order_config.each do |config|
          data << { "reference" => order.reference, "service_up" => config.up_config, "service_down" => config.down_config }
        end
      end

      data.to_json
    end

    get '/service' do
      # This fetches a list of services and their fields
      content_type 'text/json'

      data = []
      Forms.exclude(:deleted => true).each do |form|
        data << { "name" => form.name, "description" => form.description, "fields" => form.defaults }
      end

      data.to_json
      end



  end


end
