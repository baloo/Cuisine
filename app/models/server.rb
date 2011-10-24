class Server < Search

  def self.search_host(hostname = nil, limit = 15, criterias = {})
    criterias[:string] = Hash.new if not criterias[:string]
    if hostname then
      criterias[:string][:nodename] = hostname
    else
      criterias[:string][:nodename] = '*'
    end

    self.search(criterias, limit=limit)
  end

end
