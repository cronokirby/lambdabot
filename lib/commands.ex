defmodule Lambdabot.Commands do
  @moduledoc """
  The main command module.
  """
  use Alchemy.Cogs
  alias Alchemy.Client
  alias Alchemy.Message
  alias Lambdabot.Throttler

  @lambda_channel Application.fetch_env!(:lambdabot, :lambda_channel)
  @lambda_role Application.fetch_env!(:lambdabot, :lambda_role)
  @lambda_timeout Application.fetch_env!(:lambdabot, :lambda_timeout)

  Cogs.def lambda(user) do
    {:ok, guild_id} = Cogs.guild_id()
    user_ids = Message.find_mentions(user, :users)
    command = :lambda
    sender = message.author.id
    with {:ok, true} <- Throttler.is_ok?(command, sender),
         {:ok, id} <- assign_lambda(guild_id, message, user_ids) do
      Cogs.say "<@&#{@lambda_role}>, say hello to <@#{id}>"
      Throttler.put_throttle(command, sender, @lambda_timeout)
    else
      {:ok, amount} ->
        Cogs.say "You need to wait #{amount} ms to use this command."
      {:error, :no_user} ->
        Cogs.say "That user doesn't seem to be a member of this guild."
      {:error, :wrong_channel} ->
        Cogs.say "This command can only be used in <##{@lambda_channel}>"
      _ ->
        Cogs.say "Sorry, an error occurred, please try again..."
    end
  end

  def assign_lambda(_guild, _msg, []) do
    {:error, :no_user}
  end
  def assign_lambda(guild_id, %{channel_id: @lambda_channel}, [id|_]) do
    with {:ok, nil} <- Client.add_role(guild_id, id, @lambda_role) do
      {:ok, id}
    end
  end
  def assign_lambda(_, _, _) do
    {:error, :wrong_channel}
  end
end
