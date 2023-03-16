defmodule Beatrix.Repo do
  use Ecto.Repo,
    otp_app: :beatrix,
    adapter: Ecto.Adapters.Postgres
end
