import Config

config :beatrix,
  ecto_repos: [Beatrix.Repo]

config :beatrix, BeatrixWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BeatrixWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Beatrix.PubSub,
  live_view: [signing_salt: "ykwIaxs8"]

config :esbuild,
  version: "0.16.4",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger, level: :debug

config :phoenix, :json_library, Jason

config :beatrix, Beatrix.Scheduler,
  jobs: [
    # Runs every midnight:
    {"@daily", {Beatrix.GithubParser.ResponseProcessing, :start_task, []}}
  ]

import_config "#{config_env()}.exs"
