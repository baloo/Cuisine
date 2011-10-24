Cuisine.controllers :run do

  get :index, :with => :id do
    @infos = Run.load(params[:id])
    puts @infos
    render 'run/show'
  end

end
