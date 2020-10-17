Sidekiq.configure_server do |config|
  config.redis = MockRedis.new if Rails.env.test?
end