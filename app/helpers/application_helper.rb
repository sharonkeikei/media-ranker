module ApplicationHelper
  def flash_class(level)
    case level.to_sym
    when :notice 
      "alert-info"
    when :success 
      "alert-success"
    when :error
      "alert-warning"
    when :alert
      "alert-error"
    when :warning
      "alert-warning"
    end
  end
end
