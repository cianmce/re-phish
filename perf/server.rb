require 'sinatra'

$count = 0

set :port, 3001

post '/' do
  $count += 1
  logger.info "count: #{$count}"
  JSON status: "ok", count: $count
end

# get '/' do
#   $count += 1
#   JSON status: "ok", count: $count
# end

get '/count' do
  JSON status: "ok", count: $count
end
