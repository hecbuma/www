class Admin::LocationsController < AdminController

  before_action :find_location, only: [:destroy, :edit, :update]

  def create
    @location = Location.create(location_params)

    if @location.persisted?
      redirect_to admin_locations_path, notice: 'Ubicación creada'
    else
      flash[:error] = "Errores: #{@location.humanized_errors}"
      render :new
    end
  end

  def destroy
    if @location.destroy
      redirect_to admin_locations_path, notice: 'Ubicación destruída'
    else
      flash[:error] = "Errores: #{@location.humanized_errors}"
      redirect_to admin_locations_path
    end
  end

  def edit
  end

  def index
    @locations = Location.all
  end

  def new
    @location = Location.new
  end

  def update
    if @location.update_attributes(location_params)
      redirect_to admin_locations_path, notice: 'Ubicación actualizada'
    else
      flash[:error] = "Errores: #{@location.humanized_errors}"
      render :edit
    end
  end

  private

  def find_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:city, :country, :state)
  end

end
