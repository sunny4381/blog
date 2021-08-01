class TrustedUrlValidator < ActiveModel::EachValidator
  class << self
    def valid?(url_like)
      uri = Addressable::URI.parse(url_like)
      uri.relative?
    rescue Error => e
      Rails.logger.debug { "  #{e.class} (#{e.message}):  #{e.backtrace.join("\n")}" }
      false
    end
  end

  def validate_each(record, attribute, value)
    return if value.blank?

    record.errors.add attribute, :trusted if !self.class.valid?(value)
  end
end
