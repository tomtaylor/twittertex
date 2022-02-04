defmodule TwittertexTest do
  use ExUnit.Case
  doctest Twittertex

  defp tweet_json(name) do
    contents = File.read!(Path.join(["test", "tweets", "#{name}.json"]))
    Jason.decode!(contents)
  end

  test "URLs and hashtags" do
    json = tweet_json("display_guidelines")

    assert Twittertex.format_tweet(json) ==
             "Along with our new <a href=\"https://twitter.com/hashtag/Twitterbird\">#Twitterbird</a>, we've also updated our Display Guidelines: <a href=\"https://dev.twitter.com/terms/display-guidelines\">dev.twitter.com/terms/display-…</a>  ^JC"
  end

  test "photo and hashtags" do
    json = tweet_json("piglets")

    assert Twittertex.format_tweet(json) ==
             "Just piggin lovely. <br /><a href=\"https://twitter.com/hashtag/smithillsfarm\">#smithillsfarm</a> <a href=\"https://twitter.com/hashtag/kunekune\">#kunekune</a> <a href=\"https://twitter.com/hashtag/piglets\">#piglets</a> <a href=\"https://twitter.com/hashtag/cuddling\">#cuddling</a> <a href=\"http://twitter.com/Smithillsfarm/status/708021177210507264/photo/1\">pic.twitter.com/mPMZlracLP</a>"
  end

  test "mentions" do
    json = tweet_json("kanye")

    assert Twittertex.format_tweet(json) ==
             "Hi <a href=\"https://twitter.com/jack\">@jack</a> Dorsey, can you guys please take down all the fake Kanye accounts."
  end

  test "extended" do
    json = tweet_json("extended")

    assert Twittertex.format_tweet(json) ==
             "<a href=\"https://twitter.com/twitter\">@twitter</a> <a href=\"https://twitter.com/TwitterDev\">@TwitterDev</a> has more details about these changes at <a href=\"https://blog.twitter.com/2016/doing-more-with-140-characters\">blog.twitter.com/2016/doing-mor…</a>.  Thanks for making <a href=\"https://twitter.com/twitter\">@twitter</a> more expressive! <a href=\"http://twitter.com/beyond_oneforty/status/743496707711733760/photo/1\">pic.twitter.com/AWmiH870F7</a>"
  end

  test "URLs and hashtags with provided link_opts" do
    json = tweet_json("display_guidelines")
    opts = [link_opts: [target: "_blank", class: "foo"]]

    assert Twittertex.format_tweet(json, opts) ==
             "Along with our new <a class=\"foo\" href=\"https://twitter.com/hashtag/Twitterbird\" target=\"_blank\">#Twitterbird</a>, we've also updated our Display Guidelines: <a class=\"foo\" href=\"https://dev.twitter.com/terms/display-guidelines\" target=\"_blank\">dev.twitter.com/terms/display-…</a>  ^JC"
  end

  test "URLs, mentions and hashtags from v2 API" do
    json = tweet_json("v2_mentions_hashtags_urls")

    assert Twittertex.format_tweet(json) ==
             "Students &amp; Researchers 🚨 Join us on January 28th for our livestream on <a href=\"http://twitch.tv/twitterdev\">twitch.tv/twitterdev</a><br /><br />@suhemparack will be hosting Emily Chen, PhD candidate at University of Southern California to discuss best practices on building datasets for research using the <a href=\"https://twitter.com/hashtag/TwitterAPI\">#TwitterAPI</a> v2 <a href=\"https://twitter.com/TwitterDev/status/1480608486144708611/photo/1\">pic.twitter.com/1PcRy2jz2d</a>"
  end
end
