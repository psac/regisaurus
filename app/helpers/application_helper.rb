module ApplicationHelper
  def ko(bind_string, tag = :div, attributes = {}, &block)
    if attributes.key? :data
      attributes[:data][:bind] = bind_string
    else
      attributes[:data] = {bind: bind_string}
    end
    if block_given?
      content_tag tag, attributes, &block
    else
      content_tag tag, '', attributes
    end
  end
end
