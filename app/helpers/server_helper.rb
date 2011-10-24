# Helper methods defined here can be accessed in any controller or view in the application

Cuisine.helpers do
  # def simple_helper_method
  #  ...
  # end
  #

  def es_search_limited(nb=15, hostname="*",filter_updated=false)
    if hostname == "*" then
      query_str="nodename:*"
    else
      query_str='nodename:"'+hostname+'"'
    end

    s=Tire.search do
      query { string query_str }
      sort { by :start_time, 'desc' }
      if filter_updated then
        filter :exists, :field => "updated_resources"
      end
      size nb
    end

    map2hash(s)
  end


end
