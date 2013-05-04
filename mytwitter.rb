require 'twitter'
require 'colorize'

Twitter.configure do |config|
  config.consumer_key = ENV['RUBYSS_TWITTER_COMSUMER_KEY']
  config.consumer_secret = ENV['RUBYSS_TWITTER_COMSUMER_SECRET']
  config.oauth_token = ENV['RUBYSS_TWITTER_ACCESS_TOKEN']
  config.oauth_token_secret = ENV['RUBYSS_TWITTER_ACCESS_TOKEN_SECRET']
end

module MyTwitter
  # get timeline
  def tl
    result = Twitter.home_timeline(count: 10)
    result.each do |r|
      puts "@#{r.user.screen_name}".green + " #{r.text}".white
    end
  end

  # tweet message
  def tw
    Twitter.update(ARGV[0]) if ARGV[0]
  end
end
