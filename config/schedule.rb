# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
# Example:
#
ENV['RAILS_ENV'] = "development"
set :output, "/home/techverx/projects/excel2/log/cron.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end


every 1.minute do
	runner "User.test_method"
  #"User.test_method"
   #User.create(:email=> "vcob@bbb.com",:password=> "sfsfsdfsdfsd",:sheet_name=> "sfsdfsdf")
end





# Learn more: http://github.com/javan/whenever
