class AddTotalMonitoredTimeToHourlyStats < ActiveRecord::Migration
  def change
    add_column :hourly_stats, :total_monitored_time, :string
  end
end
