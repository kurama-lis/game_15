module ApplicationHelper

  def format_time(seconds)
    minutes = seconds / 60
    sec = seconds % 60
    "#{minutes}:#{sec.to_s.rjust(2, '0')}"
  end
end
