module ApplicationHelper
  def full_title(page_title)
    page_title.blank? ? BASE_TITLE : "#{page_title} - #{BASE_TITLE}"
  end

  def bootstrap_alert(key)
    case key
    when "notice"
      "success"
    when "alert"
      "danger"
    else
      key
    end
  end
end
