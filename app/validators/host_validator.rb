class HostValidator < ActiveModel::EachValidator
  # 厳密な仕様では "_" の使用は許可されていないが、歴史的に用いられている（と思う）ので許可する。
  RELAXED_SAFE_HOST_REGEX = /\A[0-9a-zA-Z\-_]+\z/

  def validate_each(record, attribute, value)
    return if value.blank?

    value.split('.').each do |part|
      next if validate_part(part)

      record.errors.add attribute, :malformed_host
      break
    end
  end

  private

  def validate_part(part)
    return false if part.blank?
    return false if part.starts_with?("-", "_")
    return false if part.ends_with?("-", "_")
    return false if !RELAXED_SAFE_HOST_REGEX.match?(part)

    true
  end
end
