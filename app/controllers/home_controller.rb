class HomeController < ApplicationController
  def index
    @followers = api_service(current_user).followers
    @following = api_service(current_user).following
    @starred = api_service(current_user).starred
    @contributions = api_service(current_user).contributions
  end
end
