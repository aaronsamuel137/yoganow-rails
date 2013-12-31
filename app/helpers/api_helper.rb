module ApiHelper
  def self.corepower_south(num_classes, start_time)
    south_b = 'https://www.healcode.com/widgets/schedules/print/xn4hucg?options[location]=110_3'
    return ApiHelper.get_healcode_data(south_b, 'Core Power South Boulder', 'http://www.corepoweryoga.com/yoga-studio/Colorado/schedule/34', num_classes, start_time)
  end

  def self.corepower_north(num_classes, start_time)
    north_b = 'https://www.healcode.com/widgets/schedules/print/m64ldzf?options%5Blocation%5D=110_12'
    return ApiHelper.get_healcode_data(north_b, 'Core Power North Boulder', 'http://www.corepoweryoga.com/yoga-studio/Colorado/schedule/32', num_classes, start_time)
  end

  def self.corepower_hill(num_classes, start_time)
    hill = 'https://www.healcode.com/widgets/schedules/print/m84u719?options[location]=110_9'
    return ApiHelper.get_healcode_data(hill, 'Core Power Hill', 'http://www.corepoweryoga.com/yoga-studio/Colorado/schedule/19', num_classes, start_time)
  end

  def self.yoga_pod(num_classes, start_time)
    url = 'http://www.healcode.com/widgets/schedules/print/dq55683k9o'
    return ApiHelper.get_healcode_data(url, 'Yoga Pod', 'http://yogapodcommunity.com/boulder/schedule', num_classes, start_time)
  end

  def self.get_studio_data(studio_name, num_classes, start_time)
    if studio_name == 'yogapod'
      return yoga_pod(num_classes, start_time)
    elsif studio_name == 'corepower_south'
      return corepower_south(num_classes, start_time)
    elsif studio_name == 'corepower_north'
      return corepower_north(num_classes, start_time)
    elsif studio_name == 'corepower_hill'
      return corepower_hill(num_classes, start_time)
    end
  end

  def self.get_healcode_data(url, studio_name, studio_link, num_classes, start_time)
    now = DateTime.now
    current_date = now.strftime("%Y-%m-%d %Z ")
    today = now.to_date

    if start_time == 'null' or start_time == '-1' or start_time = -1
      begin_time = now
    else
      begin_time = DateTime.strptime(current_date + start_time, "%Y-%m-%d %Z %H")
    end

    params = {:day => today, :studio => studio_name}
    classes = YogaClass.where("day = ? AND studio = ?", params[:day], params[:studio])

    # if classes for today are already in the db, pull directly without scraping the web
    if classes.size > 0
      class_list = Array.new

      class_num = 0
      classes.each do |clas|
        if DateTime.strptime(current_date + clas.start, "%Y-%m-%d %Z %H:%M %p") >= begin_time
          class_data = {'class_name' => clas.name, 'start_time' => clas.start, 'end_time' => clas.end, 'date' => clas.day}
          class_list.push(class_data)
          class_num += 1
          if num_classes > 0 and class_num >= num_classes
            break
          end
        end
      end

      data = {'studio_name' => studio_name,
              'class_list' => class_list,
              'link' => studio_link}
      return data

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
      get_healcode_data(url, studio_name, studio_link, num_classes, start_time)
    end
  end
end
