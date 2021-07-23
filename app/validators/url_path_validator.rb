class UrlPathValidator < ActiveModel::EachValidator
  # period is not allowed
  STRICT_SAFE_PATH_REGEX = /\A[0-9a-zA-Z\-_]+\z/

  def validate_each(record, attribute, value)
    return if value.blank?

    if !value.starts_with?('/')
      record.errors.add attribute, :malformed_path
      return
    end

    value = value[1..] # if value.starts_with?('/')
    value = value[..-2] if value.ends_with?('/')
    path_parts = value.split('/')
    path_parts.each do |path_part|
      if path_part.blank?
        record.errors.add attribute, :malformed_path
        break
      end

      if !STRICT_SAFE_PATH_REGEX.match?(path_part)
        record.errors.add attribute, :malformed_path
        break
      end
    end
  end
end
