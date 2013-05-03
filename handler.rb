require_relative "mytwitter"
require_relative "downloader"

class Handler
  include MyTwitter
  include Downloader

  def sayhello
    puts "Hi, #{%x(echo $USER)}"
  end

  def method_missing(action, *args)
    puts "I don't understand what you mean. Please check your command"
  end
end
