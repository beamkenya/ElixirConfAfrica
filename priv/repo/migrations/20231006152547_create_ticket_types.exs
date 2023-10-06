defmodule ElixirConfAfrica.Repo.Migrations.CreateTicketTypes do
  use Ecto.Migration

  def change do
    create table(:ticket_types) do
      add :name, :string, null: false
      add :description, :text, null: false
      add :price, :decimal, null: false
      add :event_id, references(:events, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:ticket_types, [:event_id])

    alter table(:events) do
      add :ticket_types, references(:ticket_types, on_delete: :nothing)
    end
  end
end
