defmodule Elixirconf.Repo.Migrations.CreateTicketTypes do
  use Ecto.Migration

  def change do
    create table(:ticket_types) do
      add :name, :string
      add :description, :text
      add :price, :integer
      add :number, :integer

      timestamps()
    end

    create unique_index(:ticket_types, [:name])
  end
end
