module ApplicationHelper
  def icon(name, opts = {})
    opts = opts.deep_symbolize_keys

    variant = opts[:variant]&.to_sym || :solid
    default_size = case variant
      when :outline, :solid
        24
      when :mini
        20
      when :micro
        16
      end

    size = opts[:size] || default_size
    classes = opts[:class] || ""
    classes += " icon block "
    raise "Do not include w-# or h-# in the class, use :size instead" if classes.match?(/(\bw-|\bh-)/)
    title = opts.delete(:title)

    if title
      direction = opts.delete(:tooltip) || 'bottom'
      data = opts.delete(:data) || {}

      content_tag(:div,
        class: classes + " tooltip tooltip-#{direction} hover:tooltip-open",
        style: "width: #{size}px; height: #{size}px;",
        data: { tip: title.to_s }.merge(data),
        **opts.except(:class, :size, :variant)
      ) do
        heroicon name, **opts.slice(:size, :variant)
      end

    else
      content_tag(:div,
        class: classes,
        style: "width: #{size}px; height: #{size}px;",
        **opts.except(:class, :size, :variant)
      ) do
        heroicon name, **opts
      end
    end
  end
end
