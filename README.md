# Poetry Robot

Poetry Robot tweets poems scraped from [PoetryFoundation.org](http://poetryfoundation.org) and retweets, follows, and replies to people!

It does these things automatically via Rake tasks executed by cron. See how some tasks can be specified in a crontab:
```
# Tweet a random poem every hour, at __:25
25 * * * * cd /path/to/directory && /path/to/rake random_poem

# Retweet somebody every 30 minutes
*/30 * * * * cd /path/to/directory && /path/to/rake retweet_a_poet

# Follow followers every 12 hours, at __:55
55 */12 * * * cd /path/to/directory && /path/to/rake follow_followers

# Reply to a poet every day at 12:50 and 19:50
50 12,19 * * * cd /path/to/directory && /path/to/rake reply_to_a_poet
```
