class AnswersController < ApplicationController
  def index
    @thema = Thema.find(params[:id])
  end

  def new
    @thema = Thema.find(params[:id])
    unless @thema.lock
      redirect_to thema_path(@thema.id), notice: 'URL未発行のため表示できません'
    else
      @question_ids = Question.where(thema_id: @thema.id).ids
      @question = Question.find(@question_ids.delete_at(0))
      @question.answers.build
    end
  end
  
  def make_session
    unless current_user
      session['url'] = request.fullpath
      redirect_to root_path
    else
      session['url'] = nil
    end
  end

  private
  def thema_params
    params.require(:answer).permit(:answer, :question_id)
  end
end
