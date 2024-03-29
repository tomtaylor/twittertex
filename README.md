# Twittertex

Twittertex formats a Map containing the JSON structure of a Tweet, and renders it to HTML for display.

It uses the tweet’s `entities` property to link to the appropriate URLs for mentions, hashtags, links and media.

## Example

```elixir
  tweet_json = Jason.decode!("""
  {
    "created_at": "Wed Jun 06 20:07:10 +0000 2012",
    "id": 210462857140252672,
    "id_str": "210462857140252672",
    "text": "Along with our new #Twitterbird, we've also updated our Display Guidelines: https://t.co/Ed4omjYs  ^JC",
    "entities": {
      "hashtags": [{ "text": "Twitterbird", "indices": [19, 31] }],
      "symbols": [],
      "user_mentions": [],
      "urls": [
        {
          "url": "https://t.co/Ed4omjYs",
          "expanded_url": "https://dev.twitter.com/terms/display-guidelines",
          "display_url": "dev.twitter.com/terms/display-\u2026",
          "indices": [76, 97]
        }
      ]
    },
    "truncated": false,
    "source": "\u003ca href=\"http://twitter.com\" rel=\"nofollow\"\u003eTwitter Web Client\u003c/a\u003e",
    "in_reply_to_status_id": null,
    "in_reply_to_status_id_str": null,
    "in_reply_to_user_id": null,
    "in_reply_to_user_id_str": null,
    "in_reply_to_screen_name": null,
    "user": {
      "id": 6253282,
      "id_str": "6253282",
      "name": "Twitter API",
      "screen_name": "twitterapi",
      "location": "San Francisco, CA",
      "description": "The Real Twitter API. I tweet about API changes, service issues and happily answer questions about Twitter and our API. Don't get an answer? It's on my website.",
      "url": "http://t.co/78pYTvWfJd",
      "entities": {
        "url": {
          "urls": [
            {
              "url": "http://t.co/78pYTvWfJd",
              "expanded_url": "http://dev.twitter.com",
              "display_url": "dev.twitter.com",
              "indices": [0, 22]
            }
          ]
        },
        "description": { "urls": [] }
      },
      "protected": false,
      "followers_count": 5779031,
      "friends_count": 47,
      "listed_count": 13048,
      "created_at": "Wed May 23 06:01:13 +0000 2007",
      "favourites_count": 27,
      "utc_offset": -25200,
      "time_zone": "Pacific Time (US & Canada)",
      "geo_enabled": true,
      "verified": true,
      "statuses_count": 3561,
      "lang": "en",
      "contributors_enabled": false,
      "is_translator": false,
      "is_translation_enabled": false,
      "profile_background_color": "C0DEED",
      "profile_background_image_url": "http://pbs.twimg.com/profile_background_images/656927849/miyt9dpjz77sc0w3d4vj.png",
      "profile_background_image_url_https": "https://pbs.twimg.com/profile_background_images/656927849/miyt9dpjz77sc0w3d4vj.png",
      "profile_background_tile": true,
      "profile_image_url": "http://pbs.twimg.com/profile_images/2284174872/7df3h38zabcvjylnyfe3_normal.png",
      "profile_image_url_https": "https://pbs.twimg.com/profile_images/2284174872/7df3h38zabcvjylnyfe3_normal.png",
      "profile_banner_url": "https://pbs.twimg.com/profile_banners/6253282/1431474710",
      "profile_link_color": "0084B4",
      "profile_sidebar_border_color": "C0DEED",
      "profile_sidebar_fill_color": "DDEEF6",
      "profile_text_color": "333333",
      "profile_use_background_image": true,
      "has_extended_profile": false,
      "default_profile": false,
      "default_profile_image": false,
      "following": false,
      "follow_request_sent": false,
      "notifications": false
    },
    "geo": null,
    "coordinates": null,
    "place": null,
    "contributors": null,
    "is_quote_status": false,
    "retweet_count": 133,
    "favorite_count": 68,
    "favorited": false,
    "retweeted": false,
    "possibly_sensitive": false,
    "possibly_sensitive_appealable": false,
    "lang": "en"
  }
  """)

  Twittertex.format_tweet(tweet_json)
  # "Along with our new <a href=\"https://twitter.com/hashtag/Twitterbird\">#Twitterbird</a>, we've also updated our Display Guidelines: <a href=\"https://dev.twitter.com/terms/display-guidelines\">dev.twitter.com/terms/display-…</a>  ^JC"
```

## Installation

Add twittertex to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:twittertex, "~> 0.3.0"}
  ]
end
```
