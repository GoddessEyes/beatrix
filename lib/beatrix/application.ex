defmodule Beatrix.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Beatrix.Repo,
      BeatrixWeb.Telemetry,
      {Phoenix.PubSub, name: Beatrix.PubSub},
      BeatrixWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Beatrix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    BeatrixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
