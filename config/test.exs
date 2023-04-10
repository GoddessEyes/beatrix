import Config

config :beatrix, Beatrix.Repo,
  username: "beatrix",
  password: "beatrix",
  hostname: "localhost",
  database: "beatrix_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :beatrix, BeatrixWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "LLGo/ejLVixVHtenIgcieBOotNwmpZvLPENt/DLp18l1mZQBRkWfKQgWQQbKg3xY",
  server: false

config :beatrix, Beatrix.Mailer, adapter: Swoosh.Adapters.Test

config :logger, level: :warn

config :phoenix, :plug_init_mode, :runtime
