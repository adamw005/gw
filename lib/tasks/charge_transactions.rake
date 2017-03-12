namespace :charge_transactions do

  desc "Everyday check to see if it's the 1st of the month and attemp transaction charges"
  task :start do

		if Time.now.day == 1

	    puts "Attempting to charge TransactionQueues"

			# Code/logic goes here
			puts Project.first.title

	    puts "Finished charging transactions..."
  	end

	end

end
