task :report => :environment do
  Daily.daily_report
end