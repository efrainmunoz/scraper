defmodule PageWatcher.Scraper do
  alias PageWatcher.{Page, Scraper}

  @callback scrape(Page.t) :: {:ok, [headers: keyword, body: String.t]} | {:error, String.t}

  def scrape!(implementation, contents) do
    case implementation.scraper(contents) do
      {:ok, data} -> data
      {:error, error} -> raise ArgumentError, "scraping error: #{error}"
    end
  end
end
