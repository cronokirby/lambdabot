defmodule Lambdabot.Throttler do
  @moduledoc """
  Intended for more long term throttling of commands, hence uses dets.
  """
  use GenServer

  def start_link(filename \\ :command_throttle) do
    GenServer.start_link(__MODULE__, {:file, filename}, name: __MODULE__)
  end

  def init({:file, filename}) do
    :dets.open_file(filename, [])
  end

  def terminate(_reason, table) do
    :dets.close(table)
    :normal
  end

  def put_throttle(command, user_id, amount) do
    GenServer.call(__MODULE__, {:put, command, user_id, amount})
  end

  def is_ok?(command, user_id) do
    GenServer.call(__MODULE__, {:is_ok, command, user_id})
  end

  defp lookup(table, key) do
    case :dets.lookup(table, key) do
      [] ->
        :none
      [{_, info}] ->
        {:ok, info}
    end
  end

  def handle_call({:put, command, user_id, amount}, _, table) do
    now = System.system_time(:millisecond)
    :dets.insert(table, {{command, user_id}, now + amount})
    {:reply, :ok, table}
  end

  def handle_call({:is_ok, command, user_id}, _, table) do
    now = System.system_time(:millisecond)
    resp =
      with {:ok, time} when time < now <- lookup(table, {command, user_id}) do
        {:ok, true}
      else
        {:ok, time} -> {:ok, time - now}
        :none -> {:error, :no_entry}
      end
    {:reply, resp, table}
  end
end
