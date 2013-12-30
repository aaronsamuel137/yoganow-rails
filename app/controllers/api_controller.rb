require 'open-uri'

class ApiController < ApplicationController
  def index()
    studio_name = params[:studio]
    num_classes = params[:num_classes]
    if studio_name == 'yogapod'
      yoga_pod(num_classes)
    elsif studio_name == 'corepower_south'
      corepower_south(num_classes)
    elsif studio_name == 'corepower_north'
      corepower_north(num_classes)
    elsif studio_name == 'corepower_hill'
      corepower_hill(num_classes)
    end
  end

  def corepower_south(num_classes)
    south_b = 'https://www.healcode.com/widgets/schedules/print/xn4hucg?options[location]=110_3'
    get_healcode_data(south_b, 'Core Power South Boulder', 'http://www.corepoweryoga.com/yoga-studio/Colorado/schedule/34', num_classes)
  end

  def corepower_north(num_classes)
    north_b = 'https://www.healcode.com/widgets/schedules/print/m64ldzf?options%5Blocation%5D=110_12'
    get_healcode_data(north_b, 'Core Power North Boulder', 'http://www.corepoweryoga.com/yoga-studio/Colorado/schedule/32', num_classes)
  end

  def corepower_hill(num_classes)
    hill = 'https://www.healcode.com/widgets/schedules/print/m84u719?options[location]=110_9'
    get_healcode_data(hill, 'Core Power Hill', 'http://www.corepoweryoga.com/yoga-studio/Colorado/schedule/19', num_classes)
  end

  def yoga_pod(num_classes)
    url = 'http://www.healcode.com/widgets/schedules/print/dq55683k9o'
    get_healcode_data(url, 'Yoga Pod', 'http://yogapodcommunity.com/boulder/schedule', num_classes)
  end

  def get_healcode_data(url, studio_name, studio_link, num_classes)
    now = DateTime.now
    current_date = now.strftime("%Y-%m-%d %Z ")
    today = now.to_date

    params = {:day => today, :studio => studio_name}
    if num_classes.to_i == -1
      classes = YogaClass.where("day = ? AND studio = ?", params[:day], params[:studio])
    else
      classes = YogaClass.where("day = ? AND studio = ?", params[:day], params[:studio]).limit(num_classes.to_i + 1)
    end

    # if classes for today are already in the db, pull directly without scraping the web
    if classes.size > 0
      class_list = Array.new

      classes.each do |clas|
        if DateTime.strptime(current_date + clas.start, "%Y-%m-%d %Z %H:%M %p") >= now
          class_data = {'class_name' => clas.name, 'start_time' => clas.start, 'end_time' => clas.end, 'date' => clas.day}
          class_list.push(class_data)
        end
      end

      data = {'studio_name' => studio_name,
              'class_list' => class_list,
              'link' => studio_link}
      render json: data

    # otherwise pull the data directly from the studio website
    else
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
          if cols.size > 2 and not day.nil? and day >= today
            class_time = cols[0].css("span span")
            start_time = class_time[0].text.strip
            end_time = class_time[1].text.delete("-").strip

            if DateTime.strptime(current_date + start_time, "%Y-%m-%d %Z %H:%M %p") >= now
              class_name = cols[1].text.strip
              # class_name = cols[1].css("a")[0].to_s
              if not cols[1].css("span")[0]["class"].include?('cancelled')
                YogaClass.create(:name => class_name, :start => start_time, :end => end_time, :day => day, :studio => studio_name)
              end
            end

          end
        end
      end
      get_healcode_data(url, studio_name, studio_link)
    end
  end
end
