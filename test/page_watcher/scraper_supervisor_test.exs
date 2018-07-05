defmodule PageWatcher.ScraperSupervisorTest do
  use ExUnit.Case

  alias PageWatcher.{ScraperSupervisor, Page}

  test "create a ScraperSupervisor" do
    {:ok, pid} = ScraperSupervisor.start_link(:ok)
    assert Process.alive?(pid)
  end

  test "add a ScraperWorker" do
    {:ok, page} = "example.com" |> URI.parse |> Page.new
    ScraperSupervisor.start_link(:ok)

    {:ok, pid} = ScraperSupervisor.add_scraper_worker(page)
    assert Process.alive?(pid)
  end
end
