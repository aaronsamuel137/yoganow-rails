class ApiController < ApplicationController
  def index()
    studio_name = params[:studio]
    if studio_name == 'yogapod'
      yoga_pod()
    end
  end

  def yoga_pod()
    now = DateTime.now
    current_date = now.strftime("%Y-%m-%d %Z ")
    today = now.to_date

    params = {:day => today}
    classes = YogaClass.where("day = ?", params[:day])

    # if classes for today are already in the db, pull directly without scraping the web
    if classes.size > 0
      class_list = Array.new

      classes.each do |clas|
        if DateTime.strptime(current_date + clas.start, "%Y-%m-%d %Z %H:%M %p") >= now
          class_data = {'class_name' => clas.name, 'start_time' => clas.start, 'end_time' => clas.end, 'date' => clas.day}
          class_list.push(class_data)
        end
      end

      data = {'studio_name' => 'Yoga Pod',
              'class_list' => class_list,
              'link' => 'http://yogapodcommunity.com/boulder/schedule'}
      render json: data

    # otherwise pull the data directly from the studio website
    else
      url = 'http://www.healcode.com/widgets/schedules/print/dq55683k9o'
      uri = URI(url)
      page = Nokogiri::HTML(open(url))
      rows = page.css("tr")
      day = nil

      rows.each do |row|
        # get the current date from header rows
        if row["class"] == "schedule_header"
          text = row.text.split()
          date_str = [text[1], text[2], text[3]].join(' ')
          day = Date.strptime(date_str, "%B %d, %Y")

        # get the class times and names from other rows
        else
          cols = row.css("td")
          puts day.strftime("The date:\t%B, %d")
          if cols.size > 2 and not day.nil?
            class_time = cols[0].css("span span")
            start_time = class_time[0].text.strip
            end_time = class_time[1].text.delete("-").strip
            class_name = cols[1].text.strip

            YogaClass.create(:name => class_name, :start => start_time, :end => end_time, :day => day)
          end
        end
      end
      yoga_pod()
    end
  end
end
