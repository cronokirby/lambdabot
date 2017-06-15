defmodule Lambdabot.Commands.Roles do
  @moduledoc """
  Contains the ability to assign language roles automatically.
  """
  use Alchemy.Cogs
  alias Alchemy.Client
  alias Alchemy.Embed
  import Embed

  @lang_roles Application.fetch_env!(:lambdabot, :lang_roles)

  Cogs.set_parser(:role, &List.wrap/1)
  Cogs.def role(requested) do
    roles = String.split(requested)
    edit_roles(message, roles, &Client.add_role/3, fn good, bad ->
      "I've given you the following roles: ```#{inspect good}```\n" <>
      case bad do
        [] -> ""
        x  -> "The following roles don't seem to be valid: ```#{inspect x}```"
      end
    end)
  end

  Cogs.set_parser(:remrole, &List.wrap/1)
  Cogs.def remrole(requested) do
    roles = String.split(requested)
    edit_roles(message, roles, &Client.remove_role/3, fn good, bad ->
      "I've removed the following roles: ```#{inspect good}```\n" <>
      case bad do
        [] -> ""
        x  -> "The following roles don't seem to be valid: ```#{inspect x}```"
      end
    end)
  end

  def edit_roles(message, roles, action, formatter) do
    {:ok, guild_id} = Cogs.guild_id()
    sender = message.author.id
    {good, bad} = Enum.reduce(roles, {[], []}, fn x, {l, r} ->
      with {:ok, role} <- Map.fetch(@lang_roles, x),
           {:ok, nil} <- action.(guild_id, sender, role)
      do
        {[x | l], r}
      else
        _ -> {l, [x | r]}
      end
    end)
    %Embed{color: 0xce67bf}
    |> description(formatter.(good, bad))
    |> Embed.send
  end
end
