defmodule SiteChecker.ResultBuilder do
  use GenServer

  ## Client API

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def result(server) do
    GenServer.call(server, :result)
  end

  def add(server, result) do
    GenServer.cast(server, {:add, result})
  end

  ## Server Callbacks

  def handle_call(:result, _from, results) do
    {:reply, results, results}
  end

  def handle_cast({:add, result}, results) do
    {:noreply, Enum.concat(results, [result])}
  end
end
