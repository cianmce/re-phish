def shut_down(n)
  puts "shut_down #{n}"
  sleep n
  puts "exiting"
end


# Trap ^C 
# Signal.trap("INT") { 
#   shut_down 5
#   exit
# }

# # Trap `Kill `
# Signal.trap("TERM") {
#   shut_down 4
#   exit
# }

while true
  begin
    puts "sleeping..."
    sleep 1
  rescue Interrupt
    puts 'Exiting loop'
    break
  end
end


while true
  begin
    puts "sleeping 2..."
    sleep 1
  rescue Interrupt
    puts 'Exiting loop 2'
    break
  end
end




