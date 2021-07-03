class UrlPathValidator < ActiveModel::EachValidator
  # period is not allowed
  STRICT_SAFE_PATH_REGEX = /\A[0-9a-zA-Z\-_]+\z/.freeze

  def validate_each(record, attribute, value)
    return if value.blank?

    unless value.starts_with?("/")
      record.errors.add attribute, :malformed_path
      return
    end

    value.split('/').each do |path_part|
      if path_part.blank?
        record.errors.add attribute, :malformed_path
        break
      end

      unless STRICT_SAFE_PATH_REGEX.match?(path_part)
        record.errors.add attribute, :malformed_path
        break
      end
    end
  end
end
