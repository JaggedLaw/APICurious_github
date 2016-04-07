class ApiService

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
    @client_id = ENV["CLIENT_ID"]
    @client_secret = ENV["CLIENT_ID"]
    @_connection = Faraday.new('https://api.github.com')
    @_connection.headers = {Authorization: "token #{current_user.oauth_token}"}
    @name = current_user.screen_name
  end

  def pro_pic
    JSON.parse(connection.get("/users/#{@name}", symbolize_names: true).body)["avatar_url"]
  end

  def followers
    JSON.parse(connection.get("/users/#{@name}/followers", symbolize_names: true).body)
  end

  def following
    # JSON.parse(connection.get("/users/#{@name}/following?client_id=#{@client_id}&client_secret=#{@client_secret}", symbolize_names: true).body)
    JSON.parse(connection.get("/users/#{@name}/following", symbolize_names: true).body)
  end

  def starred
    JSON.parse(connection.get("/users/#{@name}/starred", symbolize_names: true).body)
  end

  def contribution_repos
    # JSON.parse(connection.get("/search/repositories?q=%20+fork:true+user:#{@name}").body)["items"]
    JSON.parse(connection.get("/users/#{@name}/repos").body)
  end

  def contributions_last_year
    repos = contribution_repos
    contributions = repos.map do |repo|
      JSON.parse(connection.get("/repos/#{@name}/#{repo["name"]}/stats/participation").body)["all"]
    end
    contributions = contributions.drop(1)
    contributions = contributions[0...-1]
    contributions = contributions.flatten
    contributions.reduce(:+)
  end

  def recent_commits
    repos = contribution_repos
    recent_repos = ["APICurious_github", "My_Coffee_Order_refactor", "AerospaceCC"]
    repo_hash = Hash.new
    repos.each_with_index do |repo, index|
      if recent_repos.include?(repo["name"])
        value = JSON.parse(connection.get("/repos/#{@name}/#{repo["name"]}/stats/commit_activity").body)
        sum_total = value.each.inject(0) do |sum, (k, v)|
          sum += k["total"]
        end
        repo_hash[repo["name"]] = sum_total
      end
    end
    return repo_hash
  end

  def following_commits
    recent_repos = Array.new
    following.each do |follower|
      recent_repos = JSON.parse(connection.get("/users/#{follower["login"]}/repos").body)
    end
    repo_hash = Hash.new
    recent_repos.first(5).each_with_index do |repo, index|
      value = JSON.parse(connection.get("/repos/#{repo["owner"]["login"]}/#{repo["name"]}/stats/commit_activity").body)
      sum_total = value.each.inject(0) do |sum, (k, v)|
        sum += k["total"]
      end
      repo_hash[repo["name"]] = sum_total
    end
    binding.pry
    return repo_hash
  end


  private
    def connection
      @_connection
    end

end
