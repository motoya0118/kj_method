class ThemasController < ApplicationController
  before_action :set_thema, only: %i[ show edit update destroy confirm lock]
  before_action :authenticate_user!, only:[:new,:create]
  before_action ->{ make_user!(params[:id]) }, except:[:new,:create]
  
  def show
    session['thema'] = @thema.id
  end

  def new
    @thema = Thema.new
    @questions = @thema.questions.build
  end

  def edit
    if @thema.lock
      redirect_to thema_path(@thema.id), notice: 'URL発行済のため編集不可です'
    end
  end

  def create
    @thema = Thema.new(thema_params)
    @thema.user_id = current_user.id  

    if @thema.save
      session['thema'] = @thema.id
      redirect_to thema_url(@thema), notice: "Thema was successfully created." 
    else
      render :new, status: :unprocessable_entity
    end
    
  end

  def update
    if @thema.update(thema_params)
      redirect_to thema_url(@thema), notice: "Thema was successfully updated." 
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @thema.destroy
    session['thema'] = nil
    redirect_to mypage_path, notice: "Thema was successfully destroyed."
  end

  def confirm
  end

  def lock
    @thema.update(lock: true)
    render :confirm
  end
  
  private
    def set_thema
      @thema = Thema.find(params[:id])
    end

    def thema_params
      params.require(:thema).permit(:name, :purpose, :lock,questions_attributes:[:id, :question,:_destroy])
    end
end
