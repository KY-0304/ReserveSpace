class Owners::ReservationsController < ApplicationController
  before_action :authenticate_owner!

  def index
    @spaces = current_owner.spaces.includes(reservations: :user)
  end
end
