import Config

config :beatrix,
  ecto_repos: [Beatrix.Repo]

github_token = System.get_env("GITHUB_TOKEN")

config :beatrix,
  token: github_token || nil

config :beatrix, BeatrixWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BeatrixWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Beatrix.PubSub,
  live_view: [signing_salt: "ykwIaxs8"]

config :esbuild, :version, "0.16.4"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger, level: :debug

config :phoenix, :json_library, Jason

config :beatrix, Beatrix.Scheduler,
  jobs: [
    # Runs every midnight:
    {"@daily", {Beatrix.GithubParser.ResponseProcessing, :start, []}}
  ]

import_config "#{config_env()}.exs"
