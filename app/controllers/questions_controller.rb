class QuestionsController < ApplicationController

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
    respond_to do |format|
      @ids = params[:question].delete(:ids).split(' ')
      @question = Question.find(question_params[:id])
      if @question.update(question_params)
        if @ids.length == 0
          format.html { redirect_to thema_path(@question.thema.id), notice: "question was successfully updated." }
          format.json { render :show, status: :ok, location: @question }
        else
          format.html { redirect_to new_question_path(id:@question.thema.id, ids:@ids), notice: "question was successfully updated." }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end
  private
  def question_params
    params.require(:question).permit(:id, answers_attributes:[:id,:answer])
  end
end
