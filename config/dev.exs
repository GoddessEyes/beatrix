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
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

config :beatrix, BeatrixWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/beatrix_web/(live|views)/.*(ex)$",
      ~r"lib/beatrix_web/templates/.*(eex)$"
    ]
  ]

Logger.add_backend({LoggerFileBackend, :info})

config :logger,
  backends: [:console, {LoggerFileBackend, :file_log}]

config :logger, :console, format: "[$level] $message\n"

config :logger, :file_log, path: "info.log"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
