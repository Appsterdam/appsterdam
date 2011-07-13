module ApplicationHelper
  def page_id
    if controller.class.name =~ /^(\w+)Controller$/
      "page-#{$1.tableize}"
    end
  end
end
