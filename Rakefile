require_relative 'lib/poetry_robot'
require 'yaml'
require 'twitter_topic_bot'

desc 'Run tests'
task :test do
  system("rspec #{__dir__}/spec")
end

task :default do
  content_preparer = Poetry::ContentPreparer.new
  credentials = YAML.load(
                  File.open('twitter.yml', &:read)
                )['twitter']

  bot = TwitterTopicBot.new(content_preparer, credentials)

  bot.schedule do |schedule|
    schedule.cron('25 * * * *') { bot.tweet }
    schedule.cron('*/30 * * * *') { bot.retweet_someone }
    schedule.cron('40 * * * *') { bot.retweet_mentions }
    schedule.cron('55 */12 * * *') { bot.follow_followers }
    schedule.cron('12 */12 * * *') { bot.follow_someone }
    schedule.cron('50 12,19 * * *') { bot.reply_to_someone }
  end

  loop { sleep 1 }
end
