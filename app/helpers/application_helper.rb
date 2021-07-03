module ApplicationHelper
  def sophon_date(time_like)
    return if time_like.blank?

    date = time_like.in_time_zone.to_date

    display_time = I18n.l(date)
    iso = date.iso8601
    content_tag(:datetime, display_time, datetime: iso, title: display_time)
  end

  def sophon_br(*args)
    args.map! do |arg|
      if arg.is_a?(String)
        arg.split(/\R/)
      else
        arg
      end
    end
    args.flatten!
    args.compact!
    args.map! { |arg| sanitize(arg.presence || "") }
    args.join("<br>").html_safe
  end
end
