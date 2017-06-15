defmodule Lambdabot.Commands.Roles do
  @moduledoc """
  Contains the ability to assign language roles automatically.
  """
  use Alchemy.Cogs
  alias Alchemy.Client
  alias Alchemy.Embed
  import Embed

  @lang_roles Application.fetch_env!(:lambdabot, :lang_roles)

  def format_list([], formatter) do
    ""
  end
  def format_list(l, formatter) do
    formatter.(inspect(l))
  end

  Cogs.set_parser(:role, &[String.split(&1)])
  Cogs.def role(roles) do
    edit_roles(message, roles, &Client.add_role/3, fn g, f, b ->
      format_list(g,
        &"I've given you the following roles ```#{&1}```"
      ) <>
      format_list(f,
       &"The following exist, but I couldn't give them to you ```#{&1}```"
      ) <>
      format_list(b,
        &"The following roles don't seem to be valid: ```#{&1}```"
      )
    end)
  end

  Cogs.set_parser(:remrole, &[String.split(&1)])
  Cogs.def remrole(roles) do
    edit_roles(message, roles, &Client.remove_role/3, fn g, f, b ->
      format_list(g,
        &"I've removed the following roles ```#{&1}```"
      ) <>
      format_list(f,
       &"The following exist, but I couldn't give them to you ```#{&1}```"
      ) <>
      format_list(b,
        &"The following roles don't seem to be valid: ```#{&1}```"
      )
    end)
  end

  def edit_roles(message, roles, action, formatter) do
    {:ok, guild_id} = Cogs.guild_id()
    sender = message.author.id
    init = %{good: [], failed: [], bad: []}
    result = roles
      |> Enum.map(&String.downcase/1)
      |> Enum.reduce(init, fn x, acc ->
        with {:ok, role} <- Map.fetch(@lang_roles, String.downcase(x)),
             {:ok, nil} <- action.(guild_id, sender, role)
        do
          Map.update(acc, :good, [], &([x | &1]))
        else
          :error -> Map.update(acc, :bad, [], &([x | &1]))
          _      -> Map.update(acc, :failed, [], &([x | &1]))
        end
    end)
    %Embed{color: 0xce67bf}
    |> description(formatter.(result.good, result.failed, result.bad))
    |> Embed.send
  end
end
