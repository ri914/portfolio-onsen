module ApplicationHelper
  def full_title(page_title: '')
    base_title = "温泉オンライン"
    if page_title.blank?
      base_title
    else
      "#{base_title} - #{page_title}"
    end
  end
end
