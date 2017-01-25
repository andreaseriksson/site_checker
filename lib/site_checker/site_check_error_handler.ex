defmodule SiteChecker.PageCheckErrorHandler do
  use GenServer

  ## Client API

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def result(server) do
    GenServer.call(server, :result)
  end

  def add(server, error) do
    GenServer.cast(server, {:add, error})
  end

  ## Server Callbacks

  def handle_call(:result, _from, errors) do
    {:reply, errors, errors}
  end

  def handle_cast({:add, error}, errors) do
    {:noreply, Enum.concat(errors, [error])}
  end
end
