module ApplicationHelper
  def html_encode (value)
    # html_escape does not escape every entity.
    ERB::Util.html_escape(value).gsub("'", "&apos;").html_safe
  end

  def strip_newlines(value)
    result = value.gsub("\n", "")
    value.html_safe? ? result.html_safe : result
  end

  def format_date(value)
    return nil unless
      value.respond_to? :acts_like_date? or value.respond_to? :to_date

    (value.respond_to?(:to_date) ? value.to_date : value).format_like('January 20, 1900')
  end
end
