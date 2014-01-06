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

  HEALCODE_STUDIOS = [CP_SOUTH_DATA, CP_NORTH_DATA, CP_HILL_DATA, YOGAPOD_DATA, YOGALOFT_DATA]

  YOGA_WORKSHOP_NAME = 'Yoga Workshop'
  YOGA_WORKSHOP_URL = 'http://ws.yogaworkshop.com/cal?callback=jQuery20206711205308577529_1388441277502&_=1388441277503'
  YOGA_WORKSHOP_LINK = 'http://yogaworkshop.com/schedule/class-schedule/'
  YOGA_WORKSHOP_DATA = StudioData.new(YOGA_WORKSHOP_NAME, YOGA_WORKSHOP_URL, YOGA_WORKSHOP_LINK)

  STUDIO_NICKNAMES = %w(yogapod corepower_north corepower_south corepower_hill yogaloft yogaworkshop)
end
