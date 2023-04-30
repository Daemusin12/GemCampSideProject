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

  def fetch_province
    request = RestClient.get("#{url}/provinces/")
    data = JSON.parse(request.body)
    data.each do |province|
      address_province = Address::Province.find_or_initialize_by(code: province['code'])
      address_province.name = province['name']
      address_province.region = Address::Region.find_by_code(province['regionCode'])
      address_province.save
    end
  end

  def fetch_district
    request = RestClient.get("#{url}/districts/")
    data = JSON.parse(request.body)
    data.each do |district|
      region = Address::Region.find_by(code: district['regionCode'])
      address_district = Address::Province.find_or_initialize_by(code: district['code'])
      address_district.name = district['name']
      address_district.region = region
      address_district.save
    end
  end

  def fetch_cities
    request = RestClient.get("#{url}/cities-municipalities/")
    data = JSON.parse(request.body)
    data.each do |city|
      address_city = Address::City.find_or_initialize_by(code: city['code'])
      address_city.name = city['name']
      address_city.province = if city['name'] == 'City of Isabela'
                                Address::Province.find_by_name('Basilan')
                              elsif city['name'] == 'City of Cotabato'
                                Address::Province.find_by_name('Maguindanao')
                              elsif city['districtCode']
                                Address::Province.find_by_code(city['districtCode'])
                              else
                                Address::Province.find_by_code(city['provinceCode'])
                              end
      address_city.save
    end
  end
  
end