require "typhoeus"
require "pp"

Typhoeus::Config.user_agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.89 Safari/537.36"

$count = 0

def done(res)
  puts "\t\t ##{$count} #{res.code}"
  $count += 1
  if $count < 200
    r = Typhoeus::Request.new(
      URL,
      method: :post,
      body: { time: "#{Time.now.to_f * 1000}" },
      params: { field1: "a field" }
    )
    r.on_complete{ |res| done(res) }
    HYDRA.queue(r)
  end
end

HYDRA = Typhoeus::Hydra.new

URL = "https://requestb.in/15uznbw1"
# URL = "https://hookb.in/vDk1L6w9"


200.times.map do
  r = Typhoeus::Request.new(
    URL,
    method: :post,
    body: { time: "#{Time.now.to_f * 1000}" },
    params: { field1: "a field" }
  )
  r.on_complete{ |res| done(res) }
  HYDRA.queue(r)
end

HYDRA.run

puts "exit"
