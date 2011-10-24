Cuisine.controllers :server do

  # Display a mashup of all resources
  get "/" do
    criterias = {}

    if params[:updatedonly] == "true" then
      criterias[:updatedonly] = true
    end

    @latest = Server.search_host(
      :limit => 20,
      :criterias => criterias)

    render 'server/index'
  end

end
