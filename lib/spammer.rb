require "typhoeus"
require "pry"
require "faker"
require "json"


class Spammer
  def initialize(form, max_concurrency: nil, min_queue_size: nil, delay: nil)
    max_concurrency ||= 500
    min_queue_size  ||= 1000
    delay           ||= 0

    @form = form
    @url = form["action"]
    @method = form["method"] || "post"
    @hydra = Typhoeus::Hydra.new(max_concurrency: max_concurrency.to_i)
    @kill = false
    @min_queue_size = min_queue_size.to_i
    @delay = delay.to_i
  end

  def build_request
    # binding.pry
    request = Typhoeus::Request.new(
      @url,
      body: self.build_body,
      method: @method
    )
    request.on_complete { |response| self.on_complete(response) }
    request
  end

  def build_body
    body = {}
    @form["inputs"].each do |input|
      key = input["name"]
      if input["value"].is_a? Hash
        value = Object.const_get(input["value"]["class"]).send(input["value"]["method"])
      else
        value = input["value"]
      end
      body[key] = value unless key.nil?
    end
    body
  end

  def populate_queue
    while self.queue_size < @min_queue_size
      @hydra.queue( self.build_request )
    end
  end

  def queue_size
    @hydra.queued_requests.length
  end

  def on_complete(response)
    if response.response_code >= 400
      puts self.queue_size
      puts response.response_code
    end
    sleep @delay if @delay > 0
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
