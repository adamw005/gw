require 'net/http'

namespace :ping do
  desc "Ping our heroku dyno every 10, 60 or 3600 min"
  task :start => :environment do
    puts "Making the attempt to ping the dyno"

    puts "Sending ping"

    uri = URI.parse('http://groundwork-1.herokuapp.com/')
    Net::HTTP.get_response(uri)

		puts Project.first.title

    puts "success..."

  end
end
