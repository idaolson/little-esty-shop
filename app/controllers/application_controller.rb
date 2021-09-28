class ApplicationController < ActionController::Base
  helper_method :name, :holidays

  def name
    json = GithubService.new
    @repo ||= Repo.new(json.get_all)
  end

  def holidays
    holiday_data = NagerService.new.find_holidays
    @holidays = holiday_data[0..2].map do |holiday|
      Holiday.new(holiday)
    end
  end

  def welcome
  end
end
