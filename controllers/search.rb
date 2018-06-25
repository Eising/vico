class Icing < Sinatra::Base
  # This is a class that handles searching

  get '/search' do
    authenticate!
    @pagetitle = "Search Results"
    query = params[:query]

    @template_results = Templates.exclude(:deleted => true).filter(:name => /#{query}/).all
    @form_results = Forms.exclude(:deleted => true).filter(:name => /#{query}/).all
    @order_results = Orders.exclude(:deleted => true).filter(:reference => /#{query}/).all

    @results = @template_results.count + @form_results.count + @order_results.count

    erb :'search/results'
  end
end
