require 'open-uri'
require 'studio_data'
require 'studio_constants'

module ApiHelper
  include StudioConstants

  def self.load_classes
    StudioConstants::HEALCODE_STUDIOS.each do |studio|
      puts "Loading data for #{studio.studio_name}"
      ApiHelper.load_healcode(studio)
      puts "Done loading data for #{studio.studio_name}"
    end

    puts "Loading data for Yoga Workshop"
    ApiHelper.load_yogaworkshop(StudioConstants::YOGA_WORKSHOP_DATA)
    puts "Done loading data for Yoga Workshop"

    puts "Loading data for Studio Be"
    ApiHelper.load_studio_be(StudioConstants::STUDIO_BE_DATA)
    puts "Done loading data for Studio Be"
  end

  def self.load_yogaworkshop(studio_data)
    now = DateTime.now.in_time_zone('Mountain Time (US & Canada)')
    current_date = now.strftime("%Y-%m-%d %Z ")
    current_month = now.strftime("%Y-%m %Z ")
    today = now.to_date

    url = studio_data.data_url
    uri = URI(url)
    page = Nokogiri::HTML(open(url)).css("p")[0].text[41..-3]
    h = JSON.load(page)
    data = h["html"]

    day = nil
    start_time = nil
    end_time = nil

    data.each_line do |line|
      if line.include?('<h3>')
        day = Date.strptime(current_month + line, "%Y-%m %Z <h3>%A (%b %d)</h3>")
      end

      if day == today
        if match = line.match(/<div class="schedule_time">\s*([0-9:]+)\s*&#8211;\s*([0-9:]+)\s*([amp]+)/)
          start_time_str, end_time_str, am_pm = match.captures
          start_time = DateTime.strptime(current_date + start_time_str + am_pm, "%Y-%m-%d %Z %l:%M%P")
          end_time = DateTime.strptime(current_date + end_time_str + am_pm, "%Y-%m-%d %Z %l:%M%P")

        elsif line =~ /<div class="class_type">([\w\s\*&-]*)/
          class_name = $1

          YogaClass.create(
            name: class_name,
            start: start_time,
            end: end_time,
            day: day,
            studio: studio_data.studio_name
          )
        end
      end
    end
  end

  def self.load_healcode(studio_data)
    now = DateTime.now.in_time_zone('Mountain Time (US & Canada)')
    current_date = now.strftime("%Y-%m-%d %Z ")
    tz = now.strftime("%Z")
    today = now.to_date

    uri = URI(studio_data.data_url)
    page = Nokogiri::HTML(open(uri))
    rows = page.css('tr')
    day = nil

    rows.each do |row|
      # get the current date from header rows
      if row['class'] == 'schedule_header'
        text = row.text.split
        date_str = [text[1], text[2], text[3], tz].join(' ')
        day = Date.strptime(date_str, "%B %d, %Y %Z")

      # get the class times and names from other rows
      else
        cols = row.css('td')
        if cols.size > 2 && !day.nil? && day == today
          class_time = cols[0].css('span span')
          start_time = DateTime.strptime(
            current_date + class_time[0].text.strip,
            "%Y-%m-%d %Z %H:%M %p"
          )
          end_time = DateTime.strptime(
            current_date + class_time[1].text.delete('-').strip,
            "%Y-%m-%d %Z %H:%M %p"
          )

          if start_time >= now
            class_name = cols[1].text.strip
            # class_name = cols[1].css("a")[0].to_s
            unless cols[1].css('span')[0]['class'].include?('cancelled')
              YogaClass.create(
                name: class_name,
                start: start_time,
                end: end_time,
                day: day,
                studio: studio_data.studio_name
              )
            end
          end
        end
      end
    end
  end

  def self.load_studio_be(studio_data)
    now = DateTime.now.in_time_zone('Mountain Time (US & Canada)')
    current_day = now.strftime("%A")
    current_date = now.strftime("%Y-%m-%d %Z ")
    today = now.to_date

    uri = URI(studio_data.data_url)
    page = Nokogiri::HTML(open(uri))
    rows = page.css('tr')
    day = nil

    rows.each do |row|
      # get the current date from header rows
      if row.css('td img').size > 0
        day = row.css('td img')[0]['alt'].split[0]

      elsif day == current_day and row.css('td').size > 3
        cols = row.css('td')
        time = cols[0].text
        class_name = cols[2].text

        if match = time.match(/([0-9:]+)-([0-9:]+)\s([amp]+)/)
          start_time_str, end_time_str, am_pm = match.captures

          if start_time_str.size < 3
            start_time_str += ':00'
          end

          if end_time_str.size < 3
            end_time_str += ':00'
          end

          start_time = DateTime.strptime(
            current_date + start_time_str + am_pm,
            "%Y-%m-%d %Z %H:%M%p"
          )
          end_time = DateTime.strptime(
            current_date + end_time_str + am_pm,
            "%Y-%m-%d %Z %H:%M%p"
          )

          YogaClass.create(
            name: class_name,
            start: start_time,
            end: end_time,
            day: today,
            studio: studio_data.studio_name
          )
        end
      end
    end
  end

  def self.get_studio_data(studio_data, num_classes, start_time)
    now = DateTime.now.in_time_zone('Mountain Time (US & Canada)')
    current_date = now.strftime("%Y-%m-%d %Z ")

    if start_time == -1
      begin_time = now
    else
      begin_time = DateTime.strptime(current_date + start_time.to_s, "%Y-%m-%d %Z %H")
    end

    params = {day: now.to_date, studio: studio_data.studio_name}
    classes = YogaClass.where("day = ? AND studio = ?", params[:day], params[:studio]).order(start: :asc)
    class_list = []
    class_ctr = 0

    classes.each do |clas|
      if clas.start >= begin_time
        class_start = clas.start.strftime("%l:%M %p")
        class_end = clas.end.strftime("%l:%M %p")
        class_data = {'class_name' => clas.name, 'start_time' => class_start, 'end_time' => class_end, 'date' => clas.day}
        class_list.push(class_data)
        class_ctr += 1

        if num_classes > 0 && class_ctr >= num_classes
          break
        end
      end
    end

    data = {'studio_name' => studio_data.studio_name,
            'class_list' => class_list,
            'link' => studio_data.link_url}
  end
end
