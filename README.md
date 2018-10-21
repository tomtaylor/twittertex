# Twittertex

Twittertex formats a Map containing the JSON structure of a Tweet, and renders it to HTML for display.

It uses the tweet’s `entities` property to link to the appropriate URLs for mentions, hashtags, links and media.

## Example

```elixir
  Twittertex.format_tweet(tweet_json)
  # "Along with our new <a href=\"https://twitter.com/hashtag/Twitterbird\">#Twitterbird</a>, we've also updated our Display Guidelines: <a href=\"https://dev.twitter.com/terms/display-guidelines\">dev.twitter.com/terms/display-…</a>  ^JC"
```

## Installation

The `twittertex` package can be installed like so:

1. Add twittertex to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:twittertex, "~> 0.1.0"}]
end
```

2. Ensure twittertex is started before your application:

```elixir
def application do
  [applications: [:twittertex]]
end
```

