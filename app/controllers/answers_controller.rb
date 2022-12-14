class AnswersController < ApplicationController
  before_action ->{ make_user!(params[:id]) }, only:[:index]
  def index
    unless params[:user_id].nil? || params[:user_id].length == 0
      @thema = Thema.find(params[:id])
      @user_id = params[:user_id].to_i
    else
      @thema = Thema.find(params[:id])
      @user_id = nil
    end
  end

  def new
    unless user_signed_in?
      session['url'] = request.fullpath
      redirect_to login_path, notice: 'login/sing_inして下さい'
    else
      @thema = Thema.find(params[:id])
      unless @thema.lock
        redirect_to thema_path(@thema.id), notice: 'URL未発行のため表示できません'
      else
        @question_ids = Question.where(thema_id: @thema.id).ids
        @question = Question.find(@question_ids.delete_at(0))
        @question.answers.build
      end
    end
  end

  private
  def thema_params
    params.require(:answer).permit(:answer, :question_id)
  end
end
