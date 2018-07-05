defmodule PageWatcher.JSONScraper do
  alias PageWatcher.{Page, Scraper}

  @behaviour Scraper

  @impl Scraper
  def scrape(%Page{type: :json, verb: :get} = page) do
    page.url
    |> URI.to_string
    |> HTTPotion.get([body: page.body, headers: page.headers])
    |> prepare_result
  end

  @impl Scraper
  def scrape(%Page{type: :json, verb: :post} = page) do
    page.url
    |> URI.to_string
    |> HTTPotion.post([body: page.body, headers: page.headers])
    |> prepare_result
  end

  defp prepare_result(response) do
    case response do
      %HTTPotion.Response{status_code: code} = response when code < 400 ->
        {:ok, response}

      %HTTPotion.Response{status_code: code} = response when code >= 400 ->
        {:error, "status_code: #{response.status_code}"}

      %HTTPotion.ErrorResponse{} = response ->
        {:error, "ErrorResponse: #{response.message}"}

      _ ->
        {:error, "Unknown response: #{response}"}
    end
  end
end
