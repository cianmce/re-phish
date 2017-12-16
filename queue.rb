require 'pry'
require 'typhoeus'

hydra = Typhoeus::Hydra.new
10.times.map{ hydra.queue(Typhoeus::Request.new("www.example.com", followlocation: true)) }
binding.pry
hydra.run
