module ApplicationHelper
  def html_encode (value)
    # html_escape does not escape every entity.
    ERB::Util.html_escape(value).gsub("'", "&apos;").html_safe
  end
end
