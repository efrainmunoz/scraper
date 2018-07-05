defmodule PageWatcher.ScraperWorkerTest do
  use ExUnit.Case

  alias PageWatcher.{Page, ScraperWorker}

  test "Create and stop a ScraperWorker" do
    {:ok, page} = "http://example.com" |> URI.parse |> Page.new

    {:ok, pid} = ScraperWorker.start_link(page)
    assert Process.alive?(pid)

    ScraperWorker.stop(pid)
    assert !Process.alive?(pid)
  end

  test "get worker's page" do
    {:ok, page} = "http://example.com" |> URI.parse |> Page.new
    {:ok, pid} = ScraperWorker.start_link(page)
    stored_page = ScraperWorker.get_page(pid)
    assert stored_page == page
  end

  test "set worker's page" do
    {:ok, page} = "http://example.com" |> URI.parse |> Page.new
    {:ok, pid} = ScraperWorker.start_link(page)

    new_page = %{page | url: URI.parse("http://example2.com")}
    ScraperWorker.set_page(pid, new_page)

    stored_page = ScraperWorker.get_page(pid)
    assert stored_page == new_page
  end

  test "get worker's freq" do
    {:ok, page} = "http://example.com" |> URI.parse |> Page.new
    {:ok, pid} = ScraperWorker.start_link(page)

    stored_freq = ScraperWorker.get_freq(pid)
    assert stored_freq == 15
  end

  test "set worker's freq" do
    {:ok, page} = "http://example.com" |> URI.parse |> Page.new
    {:ok, pid} = ScraperWorker.start_link(page)

    ScraperWorker.set_freq(pid, 30)
    stored_freq = ScraperWorker.get_freq(pid)
    assert stored_freq == 30

    ScraperWorker.set_freq(pid, 0)
    stored_freq = ScraperWorker.get_freq(pid)
    assert stored_freq == 30

    ScraperWorker.set_freq(pid, -1)
    stored_freq = ScraperWorker.get_freq(pid)
    assert stored_freq == 30
  end

  test "get worker's status" do
    {:ok, page} = "http://example.com" |> URI.parse |> Page.new
    {:ok, pid} = ScraperWorker.start_link(page)

    status = ScraperWorker.get_status(pid)
    assert status == :idle
  end

  test "get worker's scrape_count" do
    {:ok, page} = "example.com/news" |> URI.parse |> Page.new
    page = %{page | type: :json}
    {:ok, pid} = ScraperWorker.start_link(page)

    scrape_count = ScraperWorker.get_scrape_count(pid)
    assert scrape_count == 0

    ScraperWorker.set_freq(pid, 1)
    ScraperWorker.start_scraper(pid)
    :timer.sleep(1000)

    scrape_count = ScraperWorker.get_scrape_count(pid)
    assert scrape_count > 0
  end

  test "start and stop the worker's scraper" do
    {:ok, page} = "example.com/news" |> URI.parse |> Page.new
    page = %{page | type: :json}
    {:ok, pid} = ScraperWorker.start_link(page)

    ScraperWorker.start_scraper(pid)
    status = ScraperWorker.get_status(pid)
    assert status == :running

    ScraperWorker.stop_scraper(pid)
    status = ScraperWorker.get_status(pid)
    assert status == :idle
  end
end
