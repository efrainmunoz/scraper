defmodule PageWatcher.ScrapersServer do
  use GenServer

  ##############
  # CLIENT API #
  ##############

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  ####################
  # SERVER CALLBACKS #
  ####################

  def init(_arg) do
    {:ok, %{}}
  end
end
