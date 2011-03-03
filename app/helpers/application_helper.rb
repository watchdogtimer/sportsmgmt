module ApplicationHelper
  def admin?
    current_user && current_user.admin?
  end
  
  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:d] == 'up' ? 'down' : 'up'
    link_to_unless condition, title, request.parameters.merge( {:c => column, :d => sort_dir} )
  end
  
  def arrow(column)
    arrow = ""
    if params[:c] == column.to_s
      arrow = params[:d] == "down" ? "&nbsp;&#8595;" : "&nbsp;&#8593;"
    end
    arrow
  end
  
  def admin_links(parent_object, object)
    html = ""
    permitted_to? :manage, object do
      parent_obj_class = parent_object.class.to_s.downcase
      obj_class = object.class.to_s.downcase
      link = parent_object ? eval("edit_#{parent_obj_class}_#{obj_class}_path(parent_object, object)") : eval("edit_#{obj_class}_path(object)")
      html << link_to('edit', link, :class => 'light small')
    end
    permitted_to? :fully_manage, object do
      html << " "
      html << link_to('destroy', object, {:confirm => 'Are you sure?', :method => :delete, :class => 'light small'})
    end
    html
  end
end
