class Share::File < Share::Base
  has_one_attached :file

  def image?
    file.content_type.present? && file.content_type.start_with?("image/")
  end

  def inline?
    file.content_type.present? && file.content_type.start_with?("application/pdf")
  end
end
