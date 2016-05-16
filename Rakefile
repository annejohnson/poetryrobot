require './lib/poetry_robot.rb'

[
  :tweet,
  :retweet_someone,
  :follow_someone,
  :retweet_mentions,
  :reply_to_someone,
  :follow_followers
].each do |task_name|
  desc task_name.to_s.gsub('_', ' ').capitalize
  task task_name do
    TwitterTopicRobot.new(
      PoetryContentPreparer.new
    ).send task_name
  end
end

desc 'Run tests'
task :test do
  system("rspec #{__dir__}/spec/**/*.rb")
end

task default: %w[test]
