class PhLocationService
  attr_reader :url

  def initialize
    @url = 'https://psgc.gitlab.io/api'
  end

  def fetch_region
    request = RestClient.get("#{url}/regions/")
    data = JSON.parse(request.body)
    data.each do |region|
      address_region = Address::Region.find_or_initialize_by(code: region['code'])
      if address_region.new_record?
        puts 'New'
      else
        puts "update record id is #{address_region.id}"
      end
      address_region.name = region['regionName']
      address_region.save
    end
  end
end