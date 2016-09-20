defmodule Twittertex do
  @moduledoc """
  Twittertex formats the raw JSON of a tweet into HTML by reconstructing pretty
  links and so on from the entities embedded.
  """

  import Phoenix.HTML
  import Phoenix.HTML.Link

  @doc """
  Formats a tweet (classic or extended) into HTML.

  Returns a String of HTML.
  """
  @spec format_tweet(%{}) :: String.t
  def format_tweet(tweet) do
    case tweet["text"] do
      nil -> format_extended_tweet(tweet)
      _ -> format_classic_tweet(tweet)
    end
  end

  @doc """
  Formats a classic (non-extended) tweet into HTML.

  Returns a String of HTML.
  """
  @spec format_classic_tweet(%{}) :: String.t
  def format_classic_tweet(tweet) do
    text = tweet["text"]
    format_tweet(tweet, text)
  end

  @doc """
  Formats an extended tweet into HTML.

  Returns a String of HTML.
  """
  @spec format_extended_tweet(%{}) :: String.t
  def format_extended_tweet(tweet) do
    text = tweet["full_text"]
    format_tweet(tweet, text)
  end

  defp format_tweet(tweet, text) do
    typed_entities = type_entities(tweet["entities"])
    format_entities(text, typed_entities) |> format_linebreaks
  end

  defp format_linebreaks(text) do
    text |> String.replace("\n", "<br />")
  end

  defp format_entities(text, []) do
    text
  end

  defp format_entities(text, [{type, entity}|entities]) do
    {text, position, offset} = case type do
      "urls" -> format_url_entity(text, entity)
      "user_mentions" -> format_user_mention(text, entity)
      "media" -> format_media_entity(text, entity)
      "hashtags" -> format_hashtag(text, entity)
      _ -> {text, 0, 0}
    end

    entities = adjust_indices(entities, position, offset)
    format_entities(text, entities)
  end

  defp format_user_mention(text, entity) do
    {start, finish} = extract_indices(entity)
    username = Map.fetch!(entity, "screen_name")
    l = link("@#{username}", to: "https://twitter.com/#{username}") |> safe_to_string
    splice(text, start, finish, l)
  end

  defp format_hashtag(text, entity) do
    {start, finish} = extract_indices(entity)
    hashtag = Map.fetch!(entity, "text")
    l = link("##{hashtag}", to: "https://twitter.com/hashtag/#{hashtag}") |> safe_to_string
    splice(text, start, finish, l)
  end

  defp format_url_entity(text, entity) do
    {start, finish} = extract_indices(entity)
    display_url = Map.fetch!(entity, "display_url")
    expanded_url = Map.fetch!(entity, "expanded_url")
    l = link(display_url, to: expanded_url) |> safe_to_string

    splice(text, start, finish, l)
  end

  defp format_media_entity(text, entity) do
    format_url_entity(text, entity)
  end

  defp splice(text, start, finish, new_text) do
    length = finish - start
    # For some reason Twitter actually uses codepoint indexes for indices, not
    # graphemes.
    codepoints = String.codepoints(text)
    {remaining, suffix} = Enum.split(codepoints, finish)
    {prefix, _} = Enum.split(remaining, start)

    text = Enum.join(prefix ++ String.codepoints(new_text) ++ suffix)
    offset = String.length(new_text) - length
    {text, start, offset}
  end

  defp extract_indices(entity) do
    case Map.get(entity, "indices") do
      nil -> nil
      indices ->
        start = Enum.at(indices, 0)
        finish = Enum.at(indices, 1)
        {start, finish}
    end
  end

  defp adjust_indices(entities, position, offset) do
    Enum.map(entities, fn({type, entity}) ->
      entity = case extract_indices(entity) do
        nil -> entity
        {start, finish} ->
          if start > position do
            Map.put(entity, "indices", [start + offset, finish + offset])
          else
            entity
          end
      end

      {type, entity}
    end)
  end

  defp type_entities(entities) do
    keys = Map.keys(entities)
    Enum.flat_map(keys, fn(k) ->
      Map.fetch!(entities, k) |> Enum.map(fn(e) -> {k, e} end)
    end)
  end

end
