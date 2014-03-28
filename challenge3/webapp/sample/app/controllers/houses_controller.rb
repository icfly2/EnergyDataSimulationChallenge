class HousesController < ApplicationController
  before_action :set_house, only: [:show, :edit, :update, :destroy]

  # GET /houses
  # GET /houses.json
  def index
    @houses = House.all
    @cities = House.select("city").group(:city).count("city")
    @cities_for_geochart = [["City", "Houses"]]
    @cities.each do |k, v|
      @cities_for_geochart += [[k, v]]
    end
  end

  # GET /houses/1
  # GET /houses/1.json
  def show
    @energies_for_gchart = [["Date", "Energy Production", "Temperature", "DayLight"]] +
        @house.energies.map do |e|
          ["#{e.year}-#{e.month}", e.energy_production, e.temperature.to_i, e.daylight.to_i]
        end
  end

  # GET /api/houses/cities
  # GET /api/houses/cities.json
  def show_cities
    @cities = House.select("city").group(:city).count("city")
  end

  # GET /houses/new
  def new
    @house = House.new
  end

  # GET /houses/1/edit
  def edit
  end

  # POST /houses
  # POST /houses.json
  def create
    @house = House.new(house_params)

    respond_to do |format|
      if @house.save
        format.html { redirect_to @house, notice: 'House was successfully created.' }
        format.json { render action: 'show', status: :created, location: @house }
      else
        format.html { render action: 'new' }
        format.json { render json: @house.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /houses/1
  # PATCH/PUT /houses/1.json
  def update
    respond_to do |format|
      if @house.update(house_params)
        format.html { redirect_to @house, notice: 'House was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @house.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /houses/1
  # DELETE /houses/1.json
  def destroy
    @house.destroy
    respond_to do |format|
      format.html { redirect_to houses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_house
      @house = House.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def house_params
      params.require(:house).permit(:firstname, :lastname, :city, :num_of_people, :has_child)
    end
end
