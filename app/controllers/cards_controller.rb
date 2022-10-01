class CardsController < ApplicationController
  def move
    @card = Card.find(params[:id])
    @card.update(card_params)
  end
  def destroy
    @card = Card.find(params[:id])
    @card.destroy
  end
  def update
    @card = Card.find(params[:id])
    @card.update(card_params)
  end
  def create
    card_id = Card.last.id + 1
    @card= Card.new(id:card_id,
                    small_group_id: card_params[:small_group_id],
                    content:card_params[:content],
                    position:card_params[:position])
    @card.save
    redirect_to edit_place_path(card_params[:place_id])
  end
  private
  def card_params
    params.require(:card).permit(:content ,:position, :small_group_id, :place_id)
  end
end