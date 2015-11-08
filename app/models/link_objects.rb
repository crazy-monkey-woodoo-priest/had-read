class LinkObjects
  def initialize(links)
    @links = links
  end

  def all
    @all ||= @links.map { |l|  Link.new(l.symbolize_keys) }
  end

  def visible
    @visible ||= all.shift(3)
  end

  def hidden
    visible
    all
  end
end
