class OwnersController < ApplicationController
  before_action :authenticate_owner!

  def index
    @rooms = current_owner.rooms
  end
end
