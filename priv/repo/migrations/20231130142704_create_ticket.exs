defmodule Elixirconf.Repo.Migrations.CreateTicket do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :name, :string
      add :email, :string
      add :ticketid, :string
      add :quantity, :integer
      add :cost, :integer
      add :ticket_type_id, references(:ticket_types, on_delete: :nothing)
      add :is_paid, :boolean, default: false
      add :is_refunded, :boolean, default: false
      add :phone_number, :string
      add :is_scanned, :boolean, default: false
      add :email_sent, :boolean, default: true

      timestamps()
    end

    create unique_index(:tickets, [:ticketid])
  end
end
