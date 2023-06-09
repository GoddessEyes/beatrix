import Config

config :beatrix, Beatrix.Repo,
  username: "beatrix",
  password: "beatrix",
  hostname: "localhost",
  database: "beatrix",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :beatrix, BeatrixWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "IBHecL6cGlT6/szKIIusG90DkcKtMjXO0fISU9h5Y3Ta2z0yv9iN+gODggbGJeU5",
  watchers: []

config :beatrix, BeatrixWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"lib/beatrix_web/(live|views)/.*(ex)$",
      ~r"lib/beatrix_web/templates/.*(eex)$"
    ]
  ]

config :logger,
  backends: [:console]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
