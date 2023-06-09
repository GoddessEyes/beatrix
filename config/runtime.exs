import Config

HTTPoison.start()

github_token = System.get_env("GITHUB_TOKEN") || ""

config :beatrix,
  token: github_token

if System.get_env("PHX_SERVER") do
  config :beatrix, BeatrixWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :beatrix, Beatrix.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "0.0.0.0"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :beatrix, BeatrixWeb.Endpoint,
    url: [host: host, port: 4000, scheme: "http"],
    http: [
      ip: {0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end
