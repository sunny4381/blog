class HostValidator < ActiveModel::EachValidator
  # 厳密な仕様では "_" の使用は許可されていないが、歴史的に用いられている（と思う）ので許可する。
  RELAXED_SAFE_HOST_REGEX = /\A[0-9a-zA-Z\-_]+\z/.freeze

  def validate_each(record, attribute, value)
    return if value.blank?

    name, port = value.split(':', 2)
    has_error = false
    name.split('.').each do |part|
      if part.blank?
        record.errors.add attribute, :malformed_host
        has_error = true
        break
      end

      if name.starts_with?("-", "_")
        record.errors.add attribute, :malformed_host
        has_error = true
        break
      end

      if name.ends_with?("-", "_")
        record.errors.add attribute, :malformed_host
        has_error = true
        break
      end

      unless RELAXED_SAFE_HOST_REGEX.match?(part)
        record.errors.add attribute, :malformed_host
        has_error = true
        break
      end
    end
    return if has_error

    if port.present? && !port.numeric?
      record.errors.add attribute, :malformed_host
    end
  end
end