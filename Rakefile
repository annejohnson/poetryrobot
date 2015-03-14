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

desc 'Tweet the contents of a string argument'
task :tweet, [:text] do |t, args|
  if args[:text].length <= PoetryRobot::MAX_TWEET_LENGTH
    PoetryRobot.new.send_tweet "#{args[:text]}"
  else
    puts "Too long to fit in a tweet. Try again."
  end
end

desc 'Retweet a poetry-related tweet'
task :retweet_poem do
  PoetryRobot.new.retweet
end

desc 'Retweet recent mentions'
task :retweet_mentions do
  PoetryRobot.new.retweet_mentions
end

desc 'Follow someone who tweeted about #poetry'
task :follow_someone do
  PoetryRobot.new.follow
end
