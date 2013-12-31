namespace :data do
  desc "Load class schedule into database."
  task :fetch => :environment do
    YogaClass.load_classes()
    puts "schedules loaded"
  end

  desc "Delete records from database older than one day."
  task :delete_old => :environment do
    YogaClass.delete_old()
    puts 'deleted'
  end
end