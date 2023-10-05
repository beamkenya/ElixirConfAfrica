defmodule ElixirConfAfrica.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string, null: false
      add :event_type, :string, null: false
      add :start_date, :naive_datetime, null: false
      add :end_date, :naive_datetime, null: false
      add :location, :string, null: false

      timestamps()
    end
  end
end
