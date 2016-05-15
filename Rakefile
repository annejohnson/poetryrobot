require './lib/poetry_robot.rb'

[
  :tweet_poem,
  :retweet_a_poet,
  :retweet_mentions,
  :follow_a_poet,
  :reply_to_a_poet,
  :follow_followers
].each do |task_name|
  desc task_name.to_s.gsub('_', ' ').capitalize
  task task_name do
    PoetryRobot.new.send task_name
  end
end

desc 'Run tests'
task :test do
  system("rspec #{__dir__}/spec/**/*.rb")
end

task default: %w[test]
