defmodule PageWatcher.ScrapersServerTest do
  use ExUnit.Case

  alias PageWatcher.{ScrapersServer}

  test "create a ScrapersServer" do
    {:ok, pid} = ScrapersServer.start_link(:ok)
    assert Process.alive?(pid)
  end
end
