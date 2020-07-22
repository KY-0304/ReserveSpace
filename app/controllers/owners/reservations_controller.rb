class Owners::ReservationsController < ApplicationController
  before_action :authenticate_owner!

  def index
    @rooms = current_owner.rooms.includes(reservations: :user)
  end

  def show
  end
end
