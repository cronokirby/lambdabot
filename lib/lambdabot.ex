defmodule Lambdabot do
  @moduledoc """
  The main starting point for the bot
  """
  use Application
  alias Alchemy.Client

  @token Application.fetch_env!(:lambdabot, :token)

  def start(_type, _args) do
    run = Client.start(@token)
    load_modules()
    run
  end

  def load_modules do
    use Lambdabot.Commands
  end
end
