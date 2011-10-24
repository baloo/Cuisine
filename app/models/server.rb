class Server < Search do
  def search_host(hostname = Nil, limit =  15, criterias = {}) 
    if hostname then
      criterias[:string][:nodename] = hostname
    else
      criterias[:string][:nodename] = '*'
    end

    search(criterias, limit=limit)
  end



end
