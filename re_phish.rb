require "typhoeus"
require "pry"
require "faker"
require "json"

class RePhish
  def initialize(config)
    # @url = config[:url]
    @config = config
    @url = config[:url]
    @min_queue_size = config[:min_queue_size]
    @method = config[:method]
    @hydra = Typhoeus::Hydra.new(max_concurrency: config[:max_concurrency])
    @kill = false
  end

  def fake(arg)
    {
      email: Faker::Internet.email
    }[arg.to_sym]
  end

  def build_request
    request = Typhoeus::Request.new(
      @url,
      body: self.build_body,
      method: @method
    )
    request.on_complete { |response| self.on_complete(response) }
    request
  end

  def build_body  
    {
      email: self.fake(:email)
    }
  end

  def populate_queue
    while @hydra.queued_requests.length < @min_queue_size
      @hydra.queue( self.build_request )
    end
  end

  def on_complete(response)
    puts @hydra.queued_requests.length
    puts response.response_code
    puts JSON.parse(response.body)["count"]
    self.populate_queue
  end

  def run_hydra
    @hydra.run
  end
  
  def run
    self.populate_queue
    self.run_hydra
  end
end

url = "https://hookb.in/KlwlXbA5"
url = "http://localhost:3001"

config = {
  min_queue_size: 100,
  max_concurrency: 100,
  url: url,
  method: :post
}

binding.pry
form_files = Dir["forms/**/*.yml"]
form_files.each_with_index do |f, i|
  puts "#{i}:\t#{f}"
end



# cnf = YAML::load_file(File.join(__dir__, 'config.yml'))

# re_phish = RePhish.new config

# re_phish.run
