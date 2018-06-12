class Icing < Sinatra::Base
    not_found do
        @pagetitle = "Page not found"
        erb :notfound
    end

end
