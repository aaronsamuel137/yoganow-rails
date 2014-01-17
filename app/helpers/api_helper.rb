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

    puts "Loading data for Adi Shakti"
    ApiHelper.load_adi_shakti(StudioConstants::ADI_SHAKTI_DATA)
    puts "Done loading data for Adi Shakti"
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

  def self.load_adi_shakti(studio_data)
    now = DateTime.now.in_time_zone('Mountain Time (US & Canada)')
    today = now.to_date

    url = studio_data.data_url
    uri = URI(url)
    data = Nokogiri::HTML(open(uri)).css('script')[2].text[33..-4]
    json = JSON.load(data)
    cids = json['cids']

    cids.each do |cid|
      entries = cid[1]['gdata']['feed']['entry']

      entries.each do |entry|
        status = entry['gd$eventStatus']['value']
        start = entry['gd$when'][0]['startTime']
        start_dt = DateTime.strptime(start, "%Y-%m-%dT%H:%M:%S.000%Z")
        start_date = start_dt.to_date

        if start_date == today && status.include?('confirmed')
          class_name = entry['title']['$t']
          class_end = entry['gd$when'][0]['endTime']
          end_dt = DateTime.strptime(class_end, "%Y-%m-%dT%H:%M:%S.000%Z")

          YogaClass.create(
            name: class_name,
            start: start_dt,
            end: end_dt,
            day: start_date,
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

    page_html = open(studio_data.data_url)
    page = Nokogiri::HTML(page_html.read)
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
          class_name = cols[1].text.strip

          begin
            description_url = cols[1].css("a")[0]['data-url']
            html = open(description_url)
            description_page = Nokogiri::HTML(html.read)
            description = description_page.css('div.class_description')[0].text
          rescue Exception => e
            puts "Error: #{e}, when getting description for class #{class_name} at studio #{studio_data.studio_name}"
            description = ''
          end

          unless cols[1].css('span')[0]['class'].include?('cancelled')
            YogaClass.create(
              name: class_name,
              start: start_time,
              end: end_time,
              day: day,
              description: description,
              studio: studio_data.studio_name
            )
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

  def self.get_studio_data(studio_data)
    now = DateTime.now.in_time_zone('Mountain Time (US & Canada)')
    current_date = now.strftime("%Y-%m-%d %Z ")

    params = {day: now.to_date, studio: studio_data.studio_name}
    classes = YogaClass.where("day = ? AND studio = ?", params[:day], params[:studio]).order(start: :asc)
    class_list = []

    classes.each do |clas|
      class_start = clas.start.strftime("%l:%M %p")
      class_end = clas.end.strftime("%l:%M %p")
      class_data = {'class_name' => clas.name,
                    'start_time' => class_start,
                    'end_time' => class_end,
                    'date' => clas.day,
                    'description' => clas.description}
      class_list.push(class_data)
    end

    data = {'studio_name' => studio_data.studio_name,
            'class_list' => class_list,
            'link' => studio_data.link_url}
  end
end
