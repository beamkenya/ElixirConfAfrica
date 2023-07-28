defmodule ElixirConfAfrica.Repo do
  use Ecto.Repo,
    otp_app: :elixir_conf_africa,
    adapter: Ecto.Adapters.Postgres
end
