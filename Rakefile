load 'poetryrobot.rb'

task default: %w[random_poem]

desc 'Tweet a random poem'
task :random_poem do
  PoetryRobot.new.send_tweet
end

desc 'Tweet the poem of the day'
task :poem_of_the_day do
  PoetryRobot.new.send_tweet :poem_of_the_day
end

desc 'Retweet a poetry-related tweet'
task :retweet_a_poet do
  PoetryRobot.new.retweet_a_poet
end

desc 'Retweet recent mentions'
task :retweet_mentions do
  PoetryRobot.new.retweet_mentions
end

desc 'Follow someone who tweeted about #poetry'
task :follow_a_poet do
  PoetryRobot.new.follow_a_poet
end

desc 'Reply to someone\'s poem tweet'
task :reply_to_a_poet do
  PoetryRobot.new.reply_to_a_poet
end

desc 'Follow new followers'
task :follow_followers do
  PoetryRobot.new.follow_followers
end
