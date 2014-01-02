require 'open-uri'
require 'studio_data'
require 'studio_constants'

module ApiHelper
  include StudioConstants

  def self.load_classes()
    threads = Array.new

    StudioConstants::STUDIOS.each do |studio|
      thread = Thread.new {
        puts "Loading data for #{studio.studio_name}"
        ApiHelper.load_db(studio)
        puts "Done loading data for #{studio.studio_name}"
      }
      threads.push(thread)
    end

    threads.each do |thread|
      thread.join()
    end
  end

  def self.load_db(studio_data)
    now = DateTime.now.in_time_zone("Mountain Time (US & Canada)")
    current_date = now.strftime("%Y-%m-%d %Z ")
    tz = now.strftime("%Z")
    today = now.to_date

    uri = URI(studio_data.data_url)
    page = Nokogiri::HTML(open(uri))
    rows = page.css("tr")
    day = nil

    rows.each do |row|
      # get the current date from header rows
      if row["class"] == "schedule_header"
        text = row.text.split()
        date_str = [text[1], text[2], text[3], tz].join(' ')
        day = Date.strptime(date_str, "%B %d, %Y %Z")

      # get the class times and names from other rows
      else
        cols = row.css("td")
        if cols.size > 2 and not day.nil? and day >= today
          class_time = cols[0].css("span span")
          start_time = DateTime.strptime(current_date + class_time[0].text.strip, "%Y-%m-%d %Z %H:%M %p")
          end_time = DateTime.strptime(current_date + class_time[1].text.delete("-").strip, "%Y-%m-%d %Z %H:%M %p")

          if start_time >= now
            class_name = cols[1].text.strip
            # class_name = cols[1].css("a")[0].to_s
            if not cols[1].css("span")[0]["class"].include?('cancelled')
              YogaClass.create(:name => class_name, :start => start_time, :end => end_time, :day => day, :studio => studio_data.studio_name)
            end
          end
        end
      end
    end
  end

  def self.get_healcode_data(studio_data, num_classes, start_time)
    now = DateTime.now.in_time_zone("Mountain Time (US & Canada)")
    current_date = now.strftime("%Y-%m-%d %Z ")

    if start_time == -1
      begin_time = now
    else
      begin_time = DateTime.strptime(current_date + start_time.to_s, "%Y-%m-%d %Z %H")
    end

    params = {:day => now.to_date, :studio => studio_data.studio_name}
    classes = YogaClass.where("day = ? AND studio = ?", params[:day], params[:studio]).order(start: :asc)
    class_list = Array.new
    class_ctr = 0

    classes.each do |clas|
      if clas.start >= begin_time
        class_start = clas.start.strftime("%l:%M %p")
        class_end = clas.end.strftime("%l:%M %p")
        class_data = {'class_name' => clas.name, 'start_time' => class_start, 'end_time' => class_end, 'date' => clas.day}
        class_list.push(class_data)
        class_ctr += 1

        if num_classes > 0 and class_ctr >= num_classes
          break
        end
      end
    end

    data = {'studio_name' => studio_data.studio_name,
            'class_list' => class_list,
            'link' => studio_data.link_url}
    return data
  end
end
