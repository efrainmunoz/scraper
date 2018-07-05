defmodule PageWatcher.ScraperSupervisor do
  use DynamicSupervisor

  ##############
  # Client API #
  ##############

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add_scraper_worker(%PageWatcher.Page{} = page) do
    child_spec = {PageWatcher.ScraperWorker, page}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def which_children() do
    DynamicSupervisor.which_children(__MODULE__)
  end

  ####################
  # Server Callbacks #
  ####################

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one) # CHANGE THIS!!!!
  end
end
