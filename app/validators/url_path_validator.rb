class UrlPathValidator < ActiveModel::EachValidator
  # period is not allowed
  STRICT_SAFE_PATH_REGEX = /\A[0-9a-zA-Z\-_]+\z/

  def validate_each(record, attribute, value)
    return if value.blank?

    unless value.starts_with?("/")
      record.errors.add attribute, :malformed_path
      return
    end

    path_parts = value.split('/')
    path_parts.each_with_index do |path_part, index|
      if path_part.blank?
        next if index == 0 || index == path_parts.length - 1

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
