# Poetry Robot

Poetry Robot tweets poems scraped from [PoetryFoundation.org](http://poetryfoundation.org) and retweets, follows, and replies to people!

## Usage

- `bundle install`
- Replace `twitter.yml.example` with a populated `twitter.yml`
- Run the bot by either:
  - issuing a rake command in the terminal. Example: `rake tweet`
  - scheduling it to run at certain times with cron. Example:

```
# Tweet a poem every hour, at __:25
25 * * * * cd /path/to/directory && /path/to/rake tweet
```
