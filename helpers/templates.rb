class Icing < Sinatra::Base

  # Returns the tags that the user can configure
  #
  # @param template_id [Integer] The database template ID
  # @return an Array of tags
  def get_configurable_tags(template_id)
    tags = get_template_tags(template_id)
    # We do not want to configure default tags
    default_tags = %w(customer location product reference)
    default_tags.each { |t| tags.delete(t) }
    # Delete Inventory keys too
    tags.each do |tag|
      if tag =~ /^inventory__/
        tags.delete(tag)
      end
    end

    tags
  end

 def get_inventory_tags(template_id)
     tags = get_template_tags(template_id)

     inventory_tags = tags.grep(/^inventory__/)

     output = {}
     inventory_tags.each do |tag|
       if res = tag.match(/^inventory__(\S+)__(\S+)__(\S+)/)
         if output.has_key? res[1]
           if output[res[1]].has_key? res[3]
             output[res[1]][res[3]] << res[2]
           else
             output[res[1]] = { res[3] => [ res[2] ] }
           end
         else
           output[res[1]] = { res[3] => [ res[2] ] }
         end
       end
     end

     output

 end

 def get_inventory_tags_raw(template_id)
     tags = get_template_tags(template_id)

     inventory_tags = tags.grep(/^inventory__/)

     inventory_tags
 end

  # Extracts all tags from a Mustache template
  #
  # @param id [Integer] the template ID from the database
  # @return The tags from both the configure and deconfigure templates
  def get_template_tags(id)
    config_text = Templates.where(:id => id).first.up_contents
    if config_text
      config = Mustache::Template.new(Templates.where(:id => id).first.up_contents).tags
    else
      config = []
    end
    deconfig_text = Templates.where(:id => id).first.down_contents
    if deconfig_text
      deconfig = Mustache::Template.new(Templates.where(:id => id).first.down_contents).tags
    else
      deconfig = []
    end
    config | deconfig
  end

  # Updates the tags in the database
  #
  # @param id [Integer] the template db ID
  # @param fields [Hash] the new value of the fields column
  def store_template_tags(id, fields)
    ds = Templates.where(:id => id)
    if ds.count == 1
      ds.update(:fields => fields.to_json)
    end
  end


  # Converts the database tags in to HTML elements
  #
  # @param fields [JSON] The fields in JSON format
  # @return an HTML table
  def tag_to_elements(fields)
    tags = JSON.parse(fields)
    #output = "<ul>\n"

    output = "<table class=\"smalltable\">\n"
    tags.each do |k,v|
      if v.class == Hash
        output += "  <tr><td>#{k} (#{v["name"]}) - #{v["value"]}</td></tr>"
      else
        output += "  <tr><td><b>#{k}</b></td><td>#{v}</td></tr>"
      end
      #output += "  <li>#{k}: #{v}</li>\n"
    end
    #output += "</u>\n"
    output += "</table>\n"
    output
  end


  # Splits key value paired tags and outputs html
  #
  # @param string [String] the key-value pair seperated with `:`
  # @return HTML string
  def tagsplit(string)
    output = ""
    arr = string.split(/,/)
    arr.each do |pair|
      (key, value) = pair.split(/:/)
      output += "<b>#{key}</b><br />#{value}<br />\n"
    end
    output
  end

  # Converts the template tags in to HTML form elements
  #
  # @param name [String] input tag name
  # @param value [String] input tag value (or nil)
  # @param klass [String] the validator css/js class (optional)
  # @param prefix [String] Prefix the input name with this (optional)
  # @return Generated HTML
  def tag_to_form(name, value=nil, klass=nil, prefix="")
    output = "<input type=\"text\" name=\"#{prefix}#{name}\" "
    if klass
      output += "class=\"required form-control #{klass}\" "
    else
      output += "class=\"required\ form-control\" "
    end
    if value
      output += "value=\"#{value}\""
    end
    output += "/>"
    output
  end

  def inventory_to_select(inventory, selector)
    entries = Sequel.pg_jsonb_op(:entries)
    inventory = Inventories.exclude(:deleted => true).where(entries.get_text('name') => inventory)
    output = "<select class=\"required form-control\" name=\"inv.#{inventory.first.id}.selector.#{selector}\">"
    inventory.first.rows.each do |row|
      output += "<option value=\"#{row.id}\">#{row.entries[selector]}</option>"
    end
    output += "</select>"
    output

  end

  def abbr_on_template(template_id, template_text)
    template = Templates.where(:id => template_id).first
    tags = template.fields
    tags.each do |tag, value|
      template_text.gsub!(/{{#{tag}}}/, "<abbr title=\"#{value}\">{{#{tag}}}</abbr>")
    end
    template_text.split("\n").join("<br> \n")
  end




end
