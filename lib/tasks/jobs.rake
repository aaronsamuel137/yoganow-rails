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

  desc "Get geo coordinates of studios with google api"
  task :get_geodata => :environment do
    endpoint = 'http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address='

    StudioConstants::STUDIO_ADDRESSES.each do |k, v|
      url = endpoint + v.gsub(/\s/, '+')
      data = open(url)
      json = JSON.load(data)
      location = json['results'][0]['geometry']['location']
      lat = location['lat']
      lng = location['lng']

      StudioLocations.create(name: k, lat: lat, lng: lng)
    end
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

  desc "Add quotes from yoga sutras to database from ashtanga website"
  task :sutra => :environment do
    (1..4).each do |chapter|
      url = "http://www.ashtangayoga.info/source-texts/yoga-sutra-patanjali/chapter-#{chapter}/"
      puts url
      TaskHelper.get_yoga_sutras(url, chapter)
    end
  end
end
