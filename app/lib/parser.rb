class Parser
  attr_reader :raw_content, :additions, :removals

  def initialize(raw_content)
    @raw_content = raw_content
    @additions = []
    @removals = []
    @mutex = Mutex.new
  end

  def call
    @mutex.synchronize do
      diff_file_lines.each do |line|
        case line
        when /^[+]\*\s+\w/
          additions << parse_line(line)
        when /^[-]\*/
          removals << parse_line(line)
        else
        end
      end
    end
  end

  private
    def diff_file_lines
      # if there was no change with 'reading.log raw_content is nil
      raw_content ? raw_content.each_line : []
    end

    def parse_line(line)
      message = (msg = line.match(/\s+#(.*)$/)) ? msg[1].strip : nil
      url = URI.extract(line).first
      { url: url, message: message }
    end
end
