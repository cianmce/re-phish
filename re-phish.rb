#!/usr/bin/env ruby
require "optparse"
require "yaml"
require "pp"
require "pry"
require_relative "lib/spammer.rb"

FORM_LIST = Dir["forms/**/*.yml"].sort

def integer?(string)
  Integer(string)
  return true
rescue ArgumentError
  return false
end

def list_form_files
  puts "Form Config List:"
  form_files = FORM_LIST
  form_files.each_with_index do |f, i|
    puts "#{i}:\t#{f}"
  end
end

def get_form_by_index(index)
  return nil unless integer?(index)
  form_files = FORM_LIST
  index = index.to_i
  return nil if index >= form_files.count
  form_files[index]
end

def spam_form(form_path, max_concurrency, delay)
  puts "form_path: #{form_path}"

  form = YAML::load_file(form_path)

  spammer = Spammer.new(form,
      max_concurrency: max_concurrency,
      min_queue_size: max_concurrency + 1,
      delay: delay
    )
  spammer.run
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: re-phish.rb [options]"

  opts.on("-g", "--generate URL", "Generates form config") do |url|
    options[:url] = url
  end

  opts.on("-l", "--list", "Lists form config") do
    options[:list] = true
  end

  opts.on("-s", "--spam [FORM_PATH]", "Path to form config to use, if no path, a menu to choose will be shown") do |form|
    options[:spam] = form
  end

  opts.on("-t", "--threads NUM_THREADS", "Number of threads") do |max_concurrency|
    options[:max_concurrency] = max_concurrency
  end

  opts.on("-d", "--delay DELAY", "Delay in seconds between requests") do |delay|
    options[:delay] = delay
  end
end.parse!

if options[:list]
  list_form_files()
  exit(0)
elsif options.keys.include? :spam
  if options[:spam].nil?
    puts "\tChoose form number to use:"
    list_form_files()
    print "> "
    form_index = gets.chomp
    options[:spam] = get_form_by_index(form_index)
  end
  spam_form(options[:spam], options[:max_concurrency].to_i, options[:delay])
elsif options[:url]
  puts "Parsing forms for '#{options[:url]}'"
else
  puts "No argument given, try:"
  puts "\tre-phish.rb -h"
  exit(1)
end
    
    


