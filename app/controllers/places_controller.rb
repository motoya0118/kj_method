class PlacesController < ApplicationController
  before_action :set_thema, only: %i[ show edit update destroy ]

  # GET /themas or /themas.json
  def index
    @places = Place.all
  end

  # GET /themas/1 or /themas/1.json
  def show
  end

  # GET /themas/new
  def new
    @place = Place.new
  end

  # GET /themas/1/edit
  def edit
  end

  # POST /themas or /themas.json
  def create
    @thema = Thema.find(params[:id])
    @place = Place.create(thema_id:@thema.id)
    @large_group = LargeGroup.create(place_id:@place.id)
    @small_group = SmallGroup.create(large_group_id: @large_group.id)
    @thema.questions.each.with_index(1) do |question,index|
      question.answers.each do |answer|
        if question.question && answer.answer
          content = "質問#{index}<br>#{answer.answer}"
          @card = Card.new(content: content, small_group_id: @small_group.id)
          @card.save!
        end
      end
    end
    redirect_to edit_place_path(@place.id)
  end

  # PATCH/PUT /themas/1 or /themas/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to thema_url(@place), notice: "thema was successfully updated." }
        format.json { }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @thema.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /themas/1 or /themas/1.json
  def destroy
    @place.destroy

    respond_to do |format|
      format.html { redirect_to places_url, notice: "thema was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thema
      @place = Place.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def place_params
      params.require(:place).permit(:public, :thema_id)
    end
end
