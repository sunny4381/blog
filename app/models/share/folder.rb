class Share::Folder < Share::Base
  def icon_source
    "<span uk-icon=\"folder\"></span>".html_safe
  end
end
