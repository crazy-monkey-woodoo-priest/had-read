module ApplicationHelper
  def alert_box(type: 'warning', &block)
    content_tag(:div, class: "alert alert-#{type} alert-dismissible", role: "alert") do
      btn = content_tag(:button, class: 'close', 'aria-label': "Close", 'data-dismiss': "alert", type: "button") do
        content_tag(:span, '&times;'.html_safe, 'aria-hidden':"true")
      end
      content = capture(&block)
      [btn, content].join.html_safe
    end
  end

  def link_link(link_object)
    link_to(link_object.url, link_object.url, title: link_object.message)
  end
end
