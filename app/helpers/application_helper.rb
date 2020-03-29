module ApplicationHelper

  def nav_link_to(link, path)
    if current_page?(path)
      link_to link, path, class: "active" 
    else
      link_to link, path
    end
  end
end
