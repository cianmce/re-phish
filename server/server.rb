require "sinatra"
require "pry"
require "json"

$count = 0
LOG_FILE = File.join(File.expand_path(File.dirname(__FILE__)), "log", "m_facebook_com.log")

get "/m.facebook.com/count" do
  {count: $count}.to_json
end

get "/m.facebook.com/reset" do
  $count = 0
  redirect "/m.facebook.com/count"
end

get "/m.facebook.com" do
  send_file "m.facebook.com/index.html"
end

post "/m.facebook.com" do
  $count += 1
  if settings.development?
    puts request.params.to_json
    open(LOG_FILE, 'a') do |f|
      f.puts request.params.to_json
    end
  end
  redirect "/m.facebook.com"
end
