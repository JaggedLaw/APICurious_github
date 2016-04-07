Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, "08afead3d9ca8feaa28e", "3977aa179edfeb728e852e4c4a411a8ec6fbd411"
end
