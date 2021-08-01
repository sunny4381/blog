class TrustedUrlValidator < ActiveModel::EachValidator
  class << self
    def valid?(url_like)
      uri = Addressable::URI.parse(url_like) rescue nil
      return false if uri.blank?

      uri.relative?
    end
  end

  def validate_each(record, attribute, value)
    return if value.blank?

    if !self.class.valid?(value)
      record.errors.add attribute, :trusted
    end
  end
end
