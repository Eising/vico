=begin

This is the routes controller. This has only one purpose, which is
pointing the default / path to the relevant controller.

=end

class Icing < Sinatra::Base

  get '/' do
    redirect to '/provision/'
  end

end
