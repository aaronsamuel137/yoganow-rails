module StudioConstants
  CP_SOUTH_NAME = 'Corepower South Boulder'
  CP_SOUTH_URL = 'https://www.healcode.com/widgets/schedules/print/xn4hucg?options[location]=110_3'
  CP_SOUTH_LINK = 'http://www.corepoweryoga.com/yoga-studio/Colorado/schedule/34'
  CP_SOUTH_DATA = StudioData.new(CP_SOUTH_NAME, CP_SOUTH_URL, CP_SOUTH_LINK)

  CP_NORTH_NAME = 'Corepower North Boulder'
  CP_NORTH_URL = 'https://www.healcode.com/widgets/schedules/print/m64ldzf?options%5Blocation%5D=110_12'
  CP_NORTH_LINK = 'http://www.corepoweryoga.com/yoga-studio/Colorado/schedule/32'
  CP_NORTH_DATA = StudioData.new(CP_NORTH_NAME, CP_NORTH_URL, CP_NORTH_LINK)

  CP_HILL_NAME = 'Corepower Hill'
  CP_HILL_URL = 'https://www.healcode.com/widgets/schedules/print/m84u719?options[location]=110_9'
  CP_HILL_LINK = 'http://www.corepoweryoga.com/yoga-studio/Colorado/schedule/19'
  CP_HILL_DATA = StudioData.new(CP_HILL_NAME, CP_HILL_URL, CP_HILL_LINK)

  YOGAPOD_NAME = 'Yogapod'
  YOGAPOD_URL = 'http://www.healcode.com/widgets/schedules/print/dq55683k9o'
  YOGAPOD_LINK = 'http://yogapodcommunity.com/boulder/schedule'
  YOGAPOD_DATA = StudioData.new(YOGAPOD_NAME, YOGAPOD_URL, YOGAPOD_LINK)

  YOGALOFT_NAME = 'Yoga Loft'
  YOGALOFT_URL = 'https://www.healcode.com/widgets/schedules/print/s15199l7ud'
  YOGALOFT_LINK = 'http://www.yogaloftboulder.com/schedule'
  YOGALOFT_DATA = StudioData.new(YOGALOFT_NAME, YOGALOFT_URL, YOGALOFT_LINK)

  RADIANCE_NAME = 'Radiance Power Yoga'
  RADIANCE_URL = 'https://www.healcode.com/widgets/schedules/print/7s4618nkp5'
  RADIANCE_LINK = 'http://radiancepoweryoga.com/faq/schedule'
  RADIANCE_DATA = StudioData.new(RADIANCE_NAME, RADIANCE_URL, RADIANCE_LINK)

  HEALCODE_STUDIOS = [CP_SOUTH_DATA, CP_NORTH_DATA, CP_HILL_DATA, YOGAPOD_DATA, YOGALOFT_DATA, RADIANCE_DATA]

  YOGA_WORKSHOP_NAME = 'Yoga Workshop'
  YOGA_WORKSHOP_URL = 'http://ws.yogaworkshop.com/cal?callback=jQuery20206711205308577529_1388441277502&_=1388441277503'
  YOGA_WORKSHOP_LINK = 'http://yogaworkshop.com/schedule/class-schedule/'
  YOGA_WORKSHOP_DATA = StudioData.new(YOGA_WORKSHOP_NAME, YOGA_WORKSHOP_URL, YOGA_WORKSHOP_LINK)

  STUDIO_BE_NAME = 'Studio Be'
  STUDIO_BE_URL = 'http://www.studiobeyoga.com/pages/V2_schedule_fees.php?print=false'
  STUDIO_BE_LINK = 'http://www.studiobeyoga.com/pages/V2_schedule_fees.php?print=false'
  STUDIO_BE_DATA = StudioData.new(STUDIO_BE_NAME, STUDIO_BE_URL, STUDIO_BE_LINK)

  ADI_SHAKTI_NAME = 'Adi Shakti'
  # ADI_SHAKTI_URL = 'https://www.google.com/calendar/embed?showTitle=0&showNav=0&showPrint=0&showTabs=0&showCalendars=0&mode=AGENDA&height=600&wkst=1&bgcolor=%23FFFFFF&src=74b03lpbo956gtpdpjjj2ak0d0%40group.calendar.google.com&color=%2323164E&src=rachel.zelaya%40gmail.com&color=%23182C57&ctz=America%2FDenver'
  ADI_SHAKTI_URL = 'https://www.google.com/calendar/embed?showCalendars=0&showTz=0&mode=WEEK&height=600&wkst=1&bgcolor=%23FFFFFF&src=74b03lpbo956gtpdpjjj2ak0d0%40group.calendar.google.com&color=%2323164E&src=rachel.zelaya%40gmail.com&color=%23182C57&ctz=America%2FDenver'
  ADI_SHAKTI_LINK = 'http://www.adishakticenter.com/kundalini-yoga-class-schedule'
  ADI_SHAKTI_DATA = StudioData.new(ADI_SHAKTI_NAME, ADI_SHAKTI_URL, ADI_SHAKTI_LINK)

  STUDIO_NICKNAMES = %w(yogapod corepower_north corepower_south corepower_hill yogaloft yogaworkshop studio_be adi_shakti radiance)
end
