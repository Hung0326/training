module MicropostsHelper
  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(
      :time,
      time.to_s,
      options.merge(datetime: time.getutc.iso8601)
    ) if time
  end

  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text :
                                  text.scan(regex).join(zero_width_space)
    end
end
