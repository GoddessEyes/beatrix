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

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Beatrix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BeatrixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
