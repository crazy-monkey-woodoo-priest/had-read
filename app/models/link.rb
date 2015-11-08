class Link
  attr_reader :url, :message

  def initialize(url: nil, message: nil)
    @url = url
    @message = message
  end
end
