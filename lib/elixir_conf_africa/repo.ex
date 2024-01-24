defmodule ElixirConfAfrica.Repo do
  use Ecto.Repo,
    otp_app: :elixir_conf_africa,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
