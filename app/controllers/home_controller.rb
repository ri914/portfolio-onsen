class HomeController < ApplicationController
  def top
  end

  def index
    @onsens = Onsen.order(created_at: :desc)
    @page_title = "ホーム"
  end
end
