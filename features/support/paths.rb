module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #

  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /the login\s?page/
      '/auth/login'

    when /the template(?:s)? page/
      '/templates/'

    when /the template compose page/
      '/templates/compose'

    when /the form(?:s)? page/
      '/forms/'

    when /the form compose page/
      '/forms/compose'

    when /the inventories page/
      '/inventories/'

    when /the add inventories page/
      '/inventories/add'

    when /the inventory called "([^\"]*)"/
      get_inventory_path($1)

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end

  def get_inventory_path(name)
    id = nil
    Inventories.where(:inventory_id => nil).exclude(:deleted => true).all.each do |inventory|
      if inventory.entries["name"] == name
        id = inventory.id
        break
      end
    end
    if id
      path = "/inventories/view/#{id}"
      return path
    else
      raise
    end
  end
end

World(NavigationHelpers)
