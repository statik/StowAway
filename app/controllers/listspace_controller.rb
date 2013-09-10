class ListspaceController < ApplicationController
  def index
    @users = User.all
  end

  def map
    @json = StorageSpace.all.to_gmaps4rails do |space, marker|
      marker.json({ :id => space.id, :notes => space.notes })
    end
    respond_to do |format|
      format.html
      format.json { render json: @json }
    end
  end
end
