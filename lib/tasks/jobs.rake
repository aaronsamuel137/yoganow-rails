namespace :data do
  desc "Load class schedule into database."
  task :fetch => :environment do
    YogaClass.load_classes()
    puts 'schedules loaded'
  end

  desc "Delete records from database older than one day."
  task :delete_old => :environment do
    YogaClass.delete_old()
    puts 'deleted'
  end
end

namespace :quote do
  desc "Add quotes from quotes.txt file into database."
  task :add => :environment do
    File.open('lib/tasks/quotes.txt').each_line do |line|
      begin
        quote, author = line.split('A:')
        Quote.create(author: author.strip, content: quote.strip)
      rescue Exception => e
        puts e
      end
    end
  end
end
