class LargeGroupsController < ApplicationController
  def move
    @place = LargeGroup.find(params[:id])
    @place.insert_at(place_params[:position].to_i)
    # render template: "kanbans/show"
  end
  def destroy
    @place = LargeGroup.find(params[:id])
    @place.destroy
  end
  def update
    @place = LargeGroup.find(params[:id])
    @place.update(place_params)
  end
  def create
    large_group_id = LargeGroup.last.id + 1
    @large_group = LargeGroup.new(id:large_group_id,
                            place_id: place_params[:place_id],
                            name:place_params[:name],
                            position:place_params[:position])
    @large_group.save
    redirect_to edit_place_path(place_params[:place_id])
  end

  private
  def place_params
    params.require(:place).permit(:name ,:position, :place_id)
  end
end