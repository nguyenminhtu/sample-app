module ApplicationHelper
  def full_title title = ""
    base_title = t "layouts.header.home"
    return base_title if title.empty?
    base_title + " | " + title
  end

  def submit_title obj
    obj.new_record? ? t("users.new.submit") : t("users.edit.submit")
  end
end
