class NagerService

  def get_data(url)
    response = Faraday.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def find_holidays
   get_data("https://date.nager.at/api/v2/NextPublicHolidays/us")
  end
  # def find_holidays
  #   holiday_data = get_data("https://date.nager.at/api/v2/NextPublicHolidays/us")
  #   holiday_hash = {}
  #   holiday_data.each do |holiday|
  #     holiday_hash[holiday[:name]] = holiday[:date]
  #   end
  #   holiday_hash
  # end
end
