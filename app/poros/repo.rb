class Repo
  attr_reader :name, :pulls, :contributors

  def initialize(repo_data)
    @name = format_name(repo_data[:name][:name])
    @pulls = repo_data[:pulls].count
    @contributors = repo_data[:contributors]
    @commits = repo_data[:commits]
  end

  def format_name(data)
    split_data = data.split("-")
    capitalized = split_data.map { |string| string.capitalize}
    capitalized.join(" ")
  end
end
