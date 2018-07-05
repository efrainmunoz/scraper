defmodule PageWatcher.Page do

  alias PageWatcher.{Page}

  @moduledoc """
  The Page module deals with Page struct creation. The Page struct
  is the fundamental block of any scraper.

  ## Examples

      iex> URI.parse("http://example.com") |> PageWatcher.Page.new
      {:ok, %PageWatcher.Page{url: URI.parse("http://example.com")}}

  """

  defstruct type: :html, verb: :get, url: %URI{}, headers: [], body: ""

  @typedoc """
  Type that represents Page structs with
    :type as atom
    :verb as atom
    :url as %URI{}
    :headers as a list
    :body as a String.t
  """
  @type t :: %Page{type: atom, verb: atom, url: %URI{}, headers: list(tuple), body: String.t}

  @doc """
  Create a new Page struct.

  ##Examples

      iex> URI.parse("http://example.com") |> PageWatcher.Page.new
      {:ok, %PageWatcher.Page{url: URI.parse("http://example.com")}}

      iex> PageWatcher.Page.new(
      ...>  :json,
      ...>  :post,
      ...>  URI.parse("http://example.com"),
      ...>  ["Content-Type": "application/json"],
      ...>  ""
      ...>)
      {:ok,
       %PageWatcher.Page{
         type: :json,
         verb: :post,
         url: URI.parse("http://example.com"),
         headers: ["Content-Type": "application/json"]
       }}

      iex> PageWatcher.Page.new()
      :error
  """
  @spec new(%URI{}) :: {:ok, t}
  def new(%URI{} = url), do: {:ok, %PageWatcher.Page{url: url}}
  def new(_args), do: :error

  @spec new(atom, atom, %URI{}, list(tuple), String.t) :: {:ok, t}
  def new(type, verb, url, headers, body) do
      {:ok, %PageWatcher.Page{type: type, verb: verb, url: url, headers: headers, body: body}}
  end

  @spec new() :: :error
  def new(), do: :error
end
