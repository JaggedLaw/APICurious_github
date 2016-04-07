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

  def contributions
    JSON.parse(connection.get("/search/repositories?q=%20+fork:true+user:#{@name}").body)["items"]
  end


  private
    def connection
      @_connection
    end

end
