class HomeController < ApplicationController
  def top
  end

  def index
    location_order_sql = Onsen.prefecture_order.map { |pref, order| "WHEN '#{pref}' THEN #{order}" }.join(' ')

    @onsens = Onsen.
      left_joins(:saved_onsens).
      group('onsens.id').
      select('onsens.*, COUNT(saved_onsens.id) AS bookmarks_count').
      order(Arel.sql("COUNT(saved_onsens.id) DESC, CASE onsens.location #{location_order_sql} ELSE 999 END, onsens.id ASC")).
      limit(10)

    @page_title = "ホーム"
  end
end
