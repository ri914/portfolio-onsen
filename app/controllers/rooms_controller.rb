class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_onsen, only: [:show, :create]

  def show
    @room = @onsen.room || @onsen.create_room
    @messages = @room.messages.includes(:user)
    @message = Message.new
    @page_title = "#{@onsen.name}の掲示板"
  end

  def create
    @room = @onsen.room || @onsen.create_room
    @message = @room.messages.build(message_params)
    @message.user = current_user

    if @message.save
      redirect_to onsen_room_path(@onsen)
    else
      @messages = @room.messages.includes(:user)
      render :show
    end
  end

  private

  def set_onsen
    @onsen = Onsen.find(params[:onsen_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
