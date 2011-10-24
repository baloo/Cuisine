Cuisine.controllers :server do
  # Display a mashup of all resources
  get "/" do
    updatedonly=false
    if params[:updatedonly] == "true" then
      updatedonly=true
    end
#    begin
#      @latest = es_search_limited(nb=20,hostname="*",filter_updated=updatedonly)
#      haml :index
#    rescue Errno::ECONNREFUSED
#      raise ES::ESUnavailable, "foo"
#    end
  end
  
end
