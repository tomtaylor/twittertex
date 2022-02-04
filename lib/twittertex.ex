defmodule Twittertex do
  @moduledoc """
  Twittertex formats the raw JSON of a tweet into HTML by reconstructing pretty
  links and so on from the entities embedded.
  """

  import Phoenix.HTML
  import Phoenix.HTML.Link

  @type opt :: {:link_opts, Keyword.t()}
  @type opts :: [opt()]

  @doc """
  Formats a tweet (classic or extended) into HTML.

  Returns a String of HTML.
  """
  @spec format_tweet(%{}) :: String.t()
  @spec format_tweet(%{}, opts()) :: String.t()
  def format_tweet(tweet, opts \\ []) do
    case tweet["text"] do
      nil -> format_extended_tweet(tweet, opts)
      _ -> format_classic_tweet(tweet, opts)
    end
  end

  @doc """
  Formats a classic (non-extended) tweet into HTML.

  Returns a String of HTML.
  """
  @spec format_classic_tweet(%{}) :: String.t()
  @spec format_classic_tweet(%{}, opts()) :: String.t()
  def format_classic_tweet(tweet, opts \\ []) do
    text = tweet["text"]
    format_tweet(tweet, text, opts)
  end

  @doc """
  Formats an extended tweet into HTML.

  Returns a String of HTML.
  """
  @spec format_extended_tweet(%{}, opts()) :: String.t()
  def format_extended_tweet(tweet, opts \\ []) do
    text = tweet["full_text"]
    format_tweet(tweet, text, opts)
  end

  defp format_tweet(tweet, text, opts) do
    typed_entities = type_entities(tweet["entities"])
    format_entities(text, typed_entities, opts) |> format_linebreaks()
  end

  defp format_linebreaks(text) do
    text |> String.replace("\n", "<br />")
  end

  defp format_entities(text, [], _opts) do
    text
  end

  defp format_entities(text, [{type, entity} | entities], opts) do
    {text, position, offset} =
      case type do
        "urls" -> format_url_entity(text, entity, opts)
        "user_mentions" -> format_user_mention(text, entity, opts)
        "media" -> format_media_entity(text, entity, opts)
        "hashtags" -> format_hashtag(text, entity, opts)
        _ -> {text, 0, 0}
      end

    entities = adjust_indices(entities, position, offset)
    format_entities(text, entities, opts)
  end

  defp format_user_mention(text, entity, opts) do
    {start, finish} = extract_indices(entity)
    username = Map.fetch!(entity, "screen_name")

    link_opts = build_link_opts(opts, "https://twitter.com/#{username}")

    l = link("@#{username}", link_opts) |> safe_to_string()
    splice(text, start, finish, l)
  end

  defp format_hashtag(text, entity, opts) do
    {start, finish} = extract_indices(entity)
    hashtag = extract_hashtag(entity)
    link_opts = build_link_opts(opts, "https://twitter.com/hashtag/#{hashtag}")
    l = link("##{hashtag}", link_opts) |> safe_to_string()
    splice(text, start, finish, l)
  end

  defp format_url_entity(text, entity, opts) do
    {start, finish} = extract_indices(entity)
    display_url = Map.fetch!(entity, "display_url")
    expanded_url = Map.fetch!(entity, "expanded_url")
    link_opts = build_link_opts(opts, expanded_url)
    l = link(display_url, link_opts) |> safe_to_string()

    splice(text, start, finish, l)
  end

  defp format_media_entity(text, entity, opts) do
    format_url_entity(text, entity, opts)
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

  defp extract_indices(%{"indices" => [start, finish]}), do: {start, finish}
  defp extract_indices(%{"start" => start, "end" => finish}), do: {start, finish}
  defp extract_indices(_entity), do: nil

  defp extract_hashtag(%{"text" => text}), do: text
  defp extract_hashtag(%{"tag" => tag}), do: tag
  defp extract_hashtag(_entity), do: throw(ArgumentError)

  defp adjust_indices(entities, position, offset) do
    Enum.map(entities, fn {type, entity} ->
      entity =
        case extract_indices(entity) do
          nil ->
            entity

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

    Enum.flat_map(keys, fn k ->
      Map.fetch!(entities, k) |> Enum.map(fn e -> {k, e} end)
    end)
  end

  defp build_link_opts(opts, to) do
    opts
    |> Keyword.get(:link_opts, [])
    |> Keyword.put(:to, to)
  end
end
