require 'open-uri'

MAX_CLASSES = 3

class ListingController < ApplicationController
  def index()
  end

  def yoga_pod()
    now = DateTime.now
    current_day = now.strftime("%B %d")
    current_time = now.strftime("%H:%M %p")
    current_date = now.strftime("%Y-%m-%d %Z ")

    url = 'http://www.healcode.com/widgets/schedules/print/dq55683k9o'
    uri = URI(url)
    page = Nokogiri::HTML(open(url))
    rows = page.css("tr")

    is_today = false
    class_list = Array.new
    rows.each do |row|
      if row["class"] == "schedule_header"
        if row.text.include?(current_day)
          is_today = true
        elsif is_today
          is_today = false
        end
      end

      if is_today
        class_time = row.css("span span")
        if class_time.length > 1
          start_time = class_time[0].text.strip
          end_time = class_time[1].text.delete("-").strip
          class_start = DateTime.strptime(current_date + start_time, "%Y-%m-%d %Z %H:%M %p")
          if not class_start < now
            class_name = row["class"].split(" ")[4].gsub('_', ' ').split(" ").map(&:capitalize).join(" ")
            class_list.push({'class_name' => class_name,
                             'start_time' => start_time,
                             'end_time'   => end_time})
          end
        end
      end

      if class_list.size >= MAX_CLASSES
        break
      end

    end
    @data = {'studio_name' => 'Yoga Pod',
             'class_list' => class_list,
             'link' => 'http://yogapodcommunity.com/boulder/schedule'}
    render json: @data
  end

  def yoga_pod_db()
    now = DateTime.now
    current_day = now.strftime("%B %d")
    current_time = now.strftime("%H:%M %p")
    current_date = now.strftime("%Y-%m-%d %Z ")
    tz = now.strftime("%Z")

    url = 'http://www.healcode.com/widgets/schedules/print/dq55683k9o'
    uri = URI(url)
    page = Nokogiri::HTML(open(url))
    rows = page.css("tr")
    rows.each do |row|

      # get the current date from header rows
      if row["class"] == "schedule_header"
        text = row.text.split()
        date_str = [text[1], text[2], text[3]].join(' ')
        day = Date.strptime(date_str, "%B %d, %Y")
        puts day.strftime("%B, %d\n-----")

      # get the class times and names from other rows
      else
        cols = row.css("td")
        if cols.size > 2
          class_time = cols[0].css("span span")
          start_time = class_time[0].text.strip
          end_time = class_time[1].text.delete("-").strip

          class_name = cols[1].text

          # puts "%s\t%s - %s" % [class_name.strip, start_time, end_time]

          YogaClass.create(:name => class_name, :start => start_time, :end => end_time, :day => day)
        end
      end
    end
  end


end
