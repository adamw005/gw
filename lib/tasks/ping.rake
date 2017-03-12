require 'net/http'

    puts "Making the attempt to ping the dyno"

    puts "Sending ping"

    uri = URI.parse('http://groundwork-1.herokuapp.com/')
    Net::HTTP.get_response(uri)

    puts "success..."
