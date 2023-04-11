defmodule Beatrix.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :beatrix,
    adapter: Ecto.Adapters.Postgres
end
