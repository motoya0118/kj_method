class SmallGroupsController < ApplicationController
  def move
    @small = SmallGroup.find(params[:id])
    @small.update(small_params)
    # render template: "kanbans/show"
  end
  def destroy
    @small = SmallGroup.find(params[:id])
    @small.destroy
  end
  def update
    @small = SmallGroup.find(params[:id])
    @small.update(small_params)
  end
  def create
    small_group_id = SmallGroup.last.id + 1
    @small= SmallGroup.new(id:small_group_id,
                            large_group_id: small_params[:large_group_id],
                            name:small_params[:name],
                            position:small_params[:position])
    @small.save
    redirect_to edit_place_path(small_params[:place_id])
  end
  private
  def small_params
    params.require(:small).permit(:name ,:position, :large_group_id, :place_id)
  end
end