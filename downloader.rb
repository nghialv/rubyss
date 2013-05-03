require 'mechanize'

module Downloader
  # run railscast num
  def railscast
    return if ARGV[0].nil?
    domain = "http://railscasts.com/"
    store_dir = "/Users/lenghia/Documents/Study/RailsCast/"
    br = Mechanize.new{|agent| agent.user_agent_alias = 'Mac Safari'}
    br.get("#{domain}episodes?utf8=%E2%9C%93&search=#{ARGV[0]}") do |p|
      begin
        path = p.at(".full").child.at("a").attributes['href'].value
        episode = path.split('/')[-1]
        `mkdir #{store_dir+episode}`
        br.get(domain+path) do |dp|
          dp.links.each do |l|
            f = l.attributes.attributes['href'].value
            if f =~ /\.mp4$/ || f =~ /\.zip$/
              fp = store_dir + episode + '/' + f.split('/')[-1]
              `curl #{f} > #{fp}`
            end
          end
        end
      rescue
        puts "Not found"
      end
    end
  end
end
