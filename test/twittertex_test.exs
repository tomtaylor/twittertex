defmodule TwittertexTest do
  use ExUnit.Case
  doctest Twittertex

  defp tweet_json(name) do
    contents = File.read!(Path.join(["test", "tweets", "#{name}.json"]))
    Poison.Parser.parse!(contents)
  end

  test "URLs and hashtags" do
    json = tweet_json("display_guidelines")
    assert Twittertex.format_tweet(json) == "Along with our new <a href=\"https://twitter.com/hashtag/Twitterbird\">#Twitterbird</a>, we've also updated our Display Guidelines: <a href=\"https://dev.twitter.com/terms/display-guidelines\">dev.twitter.com/terms/display-…</a>  ^JC"
  end

  test "photo and hashtags" do
    json = tweet_json("piglets")
    assert Twittertex.format_tweet(json) == "Just piggin lovely. <br /><a href=\"https://twitter.com/hashtag/smithillsfarm\">#smithillsfarm</a> <a href=\"https://twitter.com/hashtag/kunekune\">#kunekune</a> <a href=\"https://twitter.com/hashtag/piglets\">#piglets</a> <a href=\"https://twitter.com/hashtag/cuddling\">#cuddling</a> <a href=\"http://twitter.com/Smithillsfarm/status/708021177210507264/photo/1\">pic.twitter.com/mPMZlracLP</a>"
  end

  test "mentions" do
    json = tweet_json("kanye")
    assert Twittertex.format_tweet(json) == "Hi <a href=\"https://twitter.com/jack\">@jack</a> Dorsey, can you guys please take down all the fake Kanye accounts."
  end

  test "extended" do
    json = tweet_json("extended")
    assert Twittertex.format_tweet(json) == "<a href=\"https://twitter.com/twitter\">@twitter</a> <a href=\"https://twitter.com/TwitterDev\">@TwitterDev</a> has more details about these changes at <a href=\"https://blog.twitter.com/2016/doing-more-with-140-characters\">blog.twitter.com/2016/doing-mor…</a>.  Thanks for making <a href=\"https://twitter.com/twitter\">@twitter</a> more expressive! <a href=\"http://twitter.com/beyond_oneforty/status/743496707711733760/photo/1\">pic.twitter.com/AWmiH870F7</a>"
  end
end
