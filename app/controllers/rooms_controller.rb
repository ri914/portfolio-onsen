class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_onsen, only: [:show, :create, :edit_message, :update_message, :thread]
  before_action :set_room, only: [:show, :edit_message, :update_message]
  before_action :set_message, only: [:edit_message, :update_message]
  before_action :ensure_correct_user, only: [:edit_message, :update_message]

  def show
    @room = @onsen.room || @onsen.create_room
    @messages = @room.messages.includes(:user, :replies).page(params[:page]).per(15)
    @message = Message.new
    @page_title = "#{@onsen.name}の掲示板"
    @start_index = (@messages.current_page - 1) * @messages.limit_value + 1

    if params[:parent_message_id].present?
      @parent_message = Message.find_by(id: params[:parent_message_id])

      if @parent_message
        parent_index = @room.messages.order(:created_at).pluck(:id).index(@parent_message.id)
        if parent_index
          @parent_page = (parent_index / 15) + 1
        end
      end
    end
  end

  def create
    @room = @onsen.room || @onsen.create_room
    @message = @room.messages.build(message_params)
    @message.user = current_user
    @message.parent_message_id = params[:parent_message_id].presence

    if @message.save
      last_page = (@room.messages.count.to_f / 15).ceil
      redirect_to onsen_room_path(@onsen, page: last_page, anchor: "message-#{@message.id}")
    else
      @messages = @room.messages.includes(:user).order(created_at: :asc).page(params[:page]).per(15)
      @start_index = (@messages.current_page - 1) * @messages.limit_value + 1
      render :show
    end
  end

  def edit_message
    if @message.editable_until.present? && Time.now > @message.editable_until
      redirect_to onsen_room_path(@onsen, anchor: "message-#{@message.id}"), alert: t("alerts.edit_expired")
    end
  end

  def update_message
    if @message.editable_until.present? && Time.now > @message.editable_until
      redirect_to onsen_room_path(@onsen, anchor: "message-#{@message.id}"), alert: t("alerts.edit_expired")
    elsif @message.update(message_params)
      message_index = @room.messages.order(:created_at).pluck(:id).index(@message.id)
      message_page = (message_index / 15) + 1 if message_index

      redirect_to onsen_room_path(@onsen, page: message_page, anchor: "message-#{@message.id}"),
      notice: t("notices.message_updated")
    else
      render :edit_message
    end
  end

  def thread
    @room = @onsen.room
    @parent_message = @room.messages.includes(:user).find_by(id: params[:parent_message_id])

    if @parent_message
      @replies = @room.messages.includes(:user).where(parent_message_id: @parent_message.id).order(:created_at)
      @messages = [@parent_message] + @replies
      @page_title = "#{@onsen.name}のスレッド表示"
    else
      redirect_to onsen_room_path(@onsen), alert: "指定されたメッセージが見つかりませんでした"
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
    params.require(:message).permit(:content, :image, :remove_image)
  end

  def ensure_correct_user
    unless @message.user == current_user
      redirect_to onsen_room_path(@onsen), alert: t("alerts.not_authorized_to_edit")
      elseif @message.editable_until.present? && Time.now > @message.editable_until
      redirect_to onsen_room_path(@onsen, anchor: "message-#{@message.id}"), alert: t("alerts.edit_expired")
    end
  end
end
