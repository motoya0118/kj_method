class ThemasController < ApplicationController
  before_action :set_thema, only: %i[ show edit update destroy confirm lock]

  # GET /themas or /themas.json
  def index
    @themas = Thema.all
  end

  # GET /themas/1 or /themas/1.json
  def show
  end

  # GET /themas/new
  def new
    @thema = Thema.new
    @questions = @thema.questions.build
  end

  # GET /themas/1/edit
  def edit
  end

  # POST /themas or /themas.json
  def create
    @thema = Thema.new(thema_params)

    respond_to do |format|
      if @thema.save
        format.html { redirect_to thema_url(@thema), notice: "Thema was successfully created." }
        format.json { render :show, status: :created, location: @thema }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @thema.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /themas/1 or /themas/1.json
  def update
    respond_to do |format|
      if @thema.update(thema_params)
        format.html { redirect_to thema_url(@thema), notice: "Thema was successfully updated." }
        format.json { render :show, status: :ok, location: @thema }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @thema.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /themas/1 or /themas/1.json
  def destroy
    @thema.destroy

    respond_to do |format|
      format.html { redirect_to themas_url, notice: "Thema was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def confirm
  end

  def lock
    @thema.update(lock: true)
    render :confirm
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thema
      @thema = Thema.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def thema_params
      params.require(:thema).permit(:name, :purpose, :lock,questions_attributes:[:id, :question,:_destroy])
    end
end
