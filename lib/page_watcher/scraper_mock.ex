defmodule PageWatcher.ScraperMock do
  alias PageWatcher.{Page, Scraper}

  @behaviour Scraper

  @impl Scraper
  def scrape(%Page{type: :json, url: %URI{path: "example.com/news"}}) do
    {:ok, [body: ~s([{"title": "Example Title"}]), headers: ["Content-Type": "application/json"]]}
  end

  @impl Scraper
  def scrape(%Page{type: :json, url: %URI{path: "example.com/unknown"}}) do
    {:error, "status_code: 400"}
  end

  @impl Scraper
  def scrape(%Page{type: :json, url: %URI{path: "exampl.com"}}) do
    {:error, "Unknown response: Something unexpected happened"}
  end
end
