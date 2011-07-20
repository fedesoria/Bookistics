module ApplicationHelper
  def html_encode (value)
    # html_escape does not escape every entity.
    ERB::Util.html_escape(value).gsub("'", "&apos;").html_safe
  end

  def strip_newlines(value)
    result = value.gsub("\n", "")
    value.html_safe? ? result.html_safe : result
  end
end
