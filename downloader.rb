require 'io/console'
require 'mechanize'

module Downloader
  # run railscast num
  def railscast
    return if ARGV[0].nil?
    domain = "http://railscasts.com/"
    store_dir = "/Users/lenghia/Documents/Study/RailsCast/"
    cookie_file_path = "/Users/lenghia/.railscast_cookies.yml"
    br = Mechanize.new{|agent| agent.user_agent_alias = 'Mac Safari'}
    br.cookie_jar.load(cookie_file_path) if File.exist?(cookie_file_path)
    # check login - download with pro account
    br.get(domain+"login?return_to=http%3A%2F%2Frailscasts.com%2F") do |p|
      if p.uri.to_s =~ /^https:\/\/github.com\/login/
        login_form = p.forms.first
        print "username: "
        login_form['login'] = STDIN.gets.chomp
        print "password: "
        login_form['password'] = STDIN.noecho(&:gets).chomp
        login_form.submit
        br.cookie_jar.save_as(cookie_file_path)
      else
        puts "already logged in"
      end
    end
    # search and download episode
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
