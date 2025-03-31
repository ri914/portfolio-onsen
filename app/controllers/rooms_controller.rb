class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_onsen, only: [:show, :create, :destroy_message]
  before_action :set_room, only: [:show, :destroy_message]
  before_action :set_message, only: [:destroy_message]

  def show
    @room = @onsen.room || @onsen.create_room
    @messages = @room.messages.includes(:user, :replies).page(params[:page]).per(15)
    @message = Message.new
    @page_title = "#{@onsen.name}の掲示板"
  end

  def create
    @room = @onsen.room || @onsen.create_room
    @message = @room.messages.build(message_params)
    @message.user = current_user
    @message.parent_message_id = params[:parent_message_id].present? ? params[:parent_message_id] : nil

    if @message.save
      redirect_to onsen_room_path(@onsen)
    else
      @messages = @room.messages.includes(:user)
      render :show
    end
  end

  def destroy_message
    if @message.user == current_user
      @message.image.purge if @message.image.attached?
      @message.destroy
      redirect_to onsen_room_path(@onsen), notice: "メッセージを削除しました。"
    else
      redirect_to onsen_room_path(@onsen), alert: "他のユーザーのメッセージは削除できません。"
    end
  end

  private

  def set_onsen
    @onsen = Onsen.find(params[:onsen_id])
  end

  def set_room
    @room = @onsen.room || @onsen.create_room
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content, :image)
  end
end
