load 'poetryrobot.rb'

task default: %w[random_poem]

task :random_poem do
  PoetryRobot.send_tweet
end

task :poem_of_the_day do
  PoetryRobot.send_tweet :poem_of_the_day
end

task :retweet_poem do
  PoetryRobot.retweet
end

task :follow_someone do
  PoetryRobot.follow
end
