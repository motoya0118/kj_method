class PlacesController < ApplicationController
  before_action :set_thema, only: %i[ show edit update destroy ]
  # new,createのparams[:id]はthemaのためexcept
  before_action ->{ make_user!(Place.find(params[:id]).thema_id) }, except:[:new,:create,:show]
  
  def show
    place = Place.find(params[:id])
    unless place.public
      make_user!(place.thema_id)
    end
  end

  def new
    make_user!(params[:id])
    @place = Place.new
    @thema = Thema.find(params[:id])
    @answer_ids = @thema.answer_user_ids
  end

  def edit
  end

  def create
    make_user!(params[:id])
    user_ids = params[:place].keys.map!(&:to_i)
    @thema = Thema.find(params[:id])
    @place = Place.create!(thema_id:@thema.id,user_id: current_user.id)
    ct = 0
    answers = []
    answers_list = []
    @thema.questions.each.with_index(1) do |question,index|
      question.answers.each do |answer|
        if question.question && answer.answer && user_ids.include?(answer.user_id)
          content = "質問#{index}\n#{answer.answer}"
          ct += 1
          answers << content
          if ct == 10
            answers_list << answers
            answers = []
            ct = 0
          end
        end
      end
    end
    if answers.length > 0
      answers_list << answers
    end
    answers_list.each do |answers|
      @large_group = LargeGroup.new(place_id:@place.id)
      @large_group.save!
      @small_group = SmallGroup.new(large_group_id: @large_group.id)
      @small_group.save!
      answers.each do |answer|
        @card = Card.new(content: answer, small_group_id: @small_group.id)
        @card.save!
      end
    end
    
    redirect_to edit_place_path(@place.id)
  end

  def update
    @place.update!(place_params)
    if params[:redirect]
      redirect_to thema_url(params[:redirect]), notice: "公開ステータスを変更しました!" 
    end
  end

  def destroy
    Card.acts_as_list_no_update do
      @place.destroy
    end
    redirect_to mypage_path
  end

  private
    def set_thema
      @place = Place.find(params[:id])
    end

    def place_params
      params.require(:place).permit(:public, :thema_id, :id)
    end
end