Cuisine.controllers :search do
  get "/" do
    render 'search/index'
  end

  post "/search" do
    criterias = {}
    criterias[:string] = {}
    criterias[:updatedonly] = false

    criterias[:string][:nodename] = params[:nodename] if params[:chk_nodename]

    criterias[:string][:updated_resources] = params[:updated_resources] if params[:chk_updated_resources]

    criterias[:string][:diffs] = params[:diffs] if params[:diffs]

    criterias[:updatedonly] = true if params[:chk_updatedonly]

    @search_params=criterias
    @results = Search.search(:criterias => criterias)
    render 'search/index'
  end


end
