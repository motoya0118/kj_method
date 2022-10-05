class QuestionsController < ApplicationController
  before_action :authenticate_user!
  def new
    @thema = Thema.find(params[:id])
    unless @thema.lock
      redirect_to thema_path(@thema.id)
    else
      @question_ids = params[:ids]
      @question = Question.find(@question_ids.delete_at(0))
      @question.answers.build
    end
  end

  def update
    @ids = params[:question].delete(:ids).split(' ')
    @question = Question.find(question_params[:id])
    if @question.update(question_params)
      if @ids.length == 0
        session['url'] = nil
        redirect_to thema_path(@question.thema.id)
      else
        redirect_to new_question_path(id:@question.thema.id, ids:@ids)
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end
  private
  def question_params
    params.require(:question).permit(:id, answers_attributes:[:id,:answer,:user_id])
  end
end
