load 'poetry_robot.rb'

task default: %w[random_poem]

desc 'Tweet a random poem'
task :random_poem do
  PoetryRobot.new.send_tweet
end

desc 'Tweet the poem of the day'
task :poem_of_the_day do
  PoetryRobot.new.send_tweet :poem_of_the_day
end

[:retweet_a_poet, :retweet_mentions, :follow_a_poet, :reply_to_a_poet, :follow_followers].each do |task_name|
  desc task_name.to_s.gsub('_', ' ').capitalize
  task task_name do
    PoetryRobot.new.send task_name
  end
end
