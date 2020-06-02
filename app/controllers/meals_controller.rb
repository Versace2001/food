class MealsController < ApplicationController
  before_action :set_meal, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def town
  [price, recipe, rating, country].compact.join(', ')
  end

  # GET /meals
  # GET /meals.json
  def index
    cookies[:booking_date] = params[:search][:booking_date]
    if params[:search].present?
      if params[:search][:category].present?
      @meals = Meal.where("town ILIKE ?", "%#{params[:search][:town]}%").where("category ILIKE ?", "%#{params[:search][:category]}%")
      else
      @meals = Meal.where("town ILIKE ?", "%#{params[:search][:town]}%")
      end
    else
      @meals = Meal.all
    end


    # authorize @meals
    # @meals = Barrow.where(town: param[:town] AND category: params[:category])
    # @meals = policy_scope(Barrow).order(created_at: :desc)
  end

  # GET /my_meals
  def my_meals
    @meals = Meal.where(user_id: current_user.id)
    @bookings = Booking.where(user_id: current_user.id)
    # authorize @meals
    # authorize @bookings
  end
  # GET /meals/1
  # GET /meals/1.json
  def show
    @booking = Booking.new
    @meals_coordinates = Meal.geocoded
    a = @meals_coordinates.find(params[:id])
        @markers =
            {
              lat: a.latitude,
              lng: a.longitude
            }
  end

  # GET /meals/new
  def new
    @meal = Meal.new
    # authorize @barrow
  end

  # GET /meals/1/edit
  def edit
  end

  # POST /meals
  # POST /meals.json
  def create
    @meal = Meal.new(meal_params)
    @meal.user = current_user
    # authorize @barrow

    respond_to do |format|
      if @meal.save
        format.html { redirect_to meal_path(@meal), notice: 'Meal was successfully created.' }
        format.json { render :show, status: :created, location: @meal }
      else
        format.html { render :new }
        format.json { render json: meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meals/1
  # PATCH/PUT /meals/1.json
  def update
    respond_to do |format|
      if @meal.update(meal_params)
        format.html { redirect_to my_meals_path, notice: 'Meal was successfully updated.' }
        format.json { render :show, status: :ok, location: @meal }
      else
        format.html { render :edit }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meals/1
  # DELETE /meals/1.json
  def destroy
    @meal.destroy
    respond_to do |format|
      format.html { redirect_to my_meals_path, notice: 'Meal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meal
      @meal = Meal.find(params[:id])
      # authorize @barrow
    end

    # Only allow a list of trusted parameters through.
    def meal_params
      params.require(:meal).permit(:name, :description, :town, :category, :price, :user_id)
    end

    def booking_params
      params.require(:booking).permit(:booking_date, :user_id, :meal_id)
    end
end
