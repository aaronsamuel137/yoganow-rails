class StudioData
  attr_accessor :studio_name
  attr_accessor :data_url
  attr_accessor :link_url

  def initialize(name, data_url, link_url)
    @studio_name = name
    @data_url = data_url
    @link_url = link_url
  end
end