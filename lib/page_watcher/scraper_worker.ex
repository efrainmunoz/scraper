defmodule PageWatcher.ScraperWorker do
  use GenServer

  @json_scraper Application.get_env(:page_watcher, :json_scraper)

  ##############
  # CLIENT API #
  ##############

  def start_link(%PageWatcher.Page{} = page, scrape_freq \\ 15) when is_integer(scrape_freq) do
    GenServer.start_link(__MODULE__, %{page: page, freq: scrape_freq, status: :idle, scrape_count: 0})
  end

  def get_page(pid) do
    GenServer.call(pid, :get_page)
  end

  def set_page(pid, %PageWatcher.Page{} = page) do
    GenServer.cast(pid, {:set_page, page})
  end

  def get_freq(pid) do
    GenServer.call(pid, :get_freq)
  end

  def set_freq(pid, scrape_freq) when is_integer(scrape_freq) do
    GenServer.cast(pid, {:set_freq, scrape_freq})
  end

  def get_status(pid) do
    GenServer.call(pid, :get_status)
  end

  def get_scrape_count(pid) do
    GenServer.call(pid, :get_scrape_count)
  end

  def start_scraper(pid) do
    GenServer.cast(pid, :start_scraper)
  end

  def stop_scraper(pid) do
    GenServer.cast(pid, :stop_scraper)
  end

  def stop(pid) do
    GenServer.stop(pid)
  end

  ####################
  # SERVER CALLBACKS #
  ####################

  @impl true
  def init(state) do
    {:ok, state}
  end

  # CALLS

  @impl true
  def handle_call(:get_page, _from, state) do
    {:reply, state.page, state}
  end

  @impl true
  def handle_call(:get_freq, _from, state) do
    {:reply, state.freq, state}
  end

  @impl true
  def handle_call(:get_status, _from, state) do
    {:reply, state.status, state}
  end

  @impl true
  def handle_call(:get_scrape_count, _from, state) do
    {:reply, state.scrape_count, state}
  end

  # CASTS

  @impl true
  def handle_cast({:set_page, page}, state) do
    {:noreply, %{state | page: page}}
  end

  @impl true
  def handle_cast({:set_freq, freq}, state) do
    case freq >= 1 do
      true ->
        {:noreply, %{state | freq: freq}}
      false ->
        {:noreply, state}
    end
  end

  @impl true
  def handle_cast(:start_scraper, state) do
    case state.status do
      :idle ->
        schedule_scrape(state.freq)
        {:noreply, %{state | status: :running}}
      :running ->
        {:noreply, state}
    end
  end

  @impl true
  def handle_cast(:stop_scraper, state) do
    {:noreply, %{state | status: :idle}}
  end

  # INFO

  @impl true
  def handle_info(:scrape, state) do
    case state.page.type do
      :json ->
        IO.puts(inspect(@json_scraper.scrape(state.page)))
      :html ->
        IO.puts("TODO")
      :browser ->
        IO.puts("TODO")
    end

    case state.status do
      :running ->
        schedule_scrape(state.freq)
        {:noreply, %{state | scrape_count: state.scrape_count + 1}}
      :idle ->
        {:noreply, state}
    end
  end

  ####################
  # HELPER FUNCTIONS #
  ####################

  defp schedule_scrape(freq) do
    Process.send_after(self(), :scrape, freq * 1000)
  end
end
