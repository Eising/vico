class Icing < Sinatra::Base
  # @!group Templates controller

  # @method get_templates
  # Administrate templates
  get '/templates' do
    authenticate!
    @pagename = "templates"
    @pagetitle = "Administrate templates"
    @templates = Templates.exclude(:deleted => true).all
    erb :'templates/templates'
  end

  # @method get_template_id
  # View template
  # @todo Handle lack of tags
  #   Prints to stderr. Necessary?
  get '/template/:id' do
    authenticate!
    # TODO: Hande lack of tags
    id = params[:id]
    @template = Templates.where(:id => id).first
    @up_template = abbr_on_template(id, @template.up_contents)
    @down_template = abbr_on_template(id, @template.down_contents)
    erb :'templates/view'
  end

  # @method get_templates_compose
  # Compose template
  get '/templates/compose' do
    authenticate!
    @pagename = "templates_compose"
    @pagetitle = "Administrate templates"
    @template = {}
    erb :'templates/compose'
  end

  # @method get_templates_edit_id
  # Edit a template
  get '/templates/edit/:id' do
    authenticate!
    @pagename = "templates_compose"
    @pagetitle = "Administrate templates"
    @template = Templates.where(:id => params[:id]).first
    @update = true
    @edit = true
    #        @forms = @template.form.all

    erb :'templates/compose'
  end

  get '/templates/clone/:id' do
    authenticate!
    @pagename = "template_compose"
    @pagetitle = "Administrate templates"
    @template = Templates.where(:id => params[:id]).first

    erb :'templates/compose'

  end


  # @method post_templates_add
  # Add a template
  post '/templates/add' do

    authenticate!
    args = { :name => params[:name], :up_contents => params[:up_contents], :platform => params[:platform], :description => params[:description], :down_contents => params[:down_contents] }
    if params[:template_id] =~ /\d+/
      template = Templates.where(:id => params[:template_id])
      template.update(args)
      id = params[:template_id]
      template.first.form.each { |form| form.update(:require_update => true) }
    else
      template = Templates.create(args)
      id = template.id
    end
    redirect to("/templates/tags/#{id}")
  end

  # @method get_templates_tags_id
  # Configure validators and datatypes for a template
  # @param id [Integer] the template ID
  get '/templates/tags/:id' do
    authenticate!
    @pagetitle = "Configure validators"
    @pagename = "templates_tags"
    id = params[:id]
    @validators = config.validators
    @templateid = id
    error = false
    begin
      @tags = get_configurable_tags(id)
    rescue Mustache::Parser::SyntaxError => @e
      error = true
    end
    if error
      Templates.where(:id => id).delete
      erb :'templates/error'
    else
      erb :'templates/tags'
    end
  end

  # @method post_template_tags
  # Submit template tags to the db
  post '/templates/tags' do
    authenticate!
    tags = {}
    params.each do |param, value|
      if param =~ /^tag\.(.*)$/
        tags[$1] = value
      end
    end
    dbid = params[:templateid]
    Templates.where(:id => dbid).update(:fields => tags.to_json)

    redirect to("/templates")
  end

  # @method get_template_delete_id
  # Deletes a template
  # @param id [Integer] the template ID to delete
  get '/template/delete/:id' do
    authenticate!
    id = params[:id]
    Templates.where(:id => id).update(:deleted => true)
    redirect to("/templates")
  end


end
