defmodule ElixirConfAfrica.TicketTypes.TicketType do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "ticket_types" do
    field :name, :string
    field :description, :string
    field :price, :integer
    field :number, :integer
    has_many :tickets, ElixirConfAfrica.Tickets.Ticket

    timestamps()
  end

  @doc false
  def changeset(ticket_type, attrs) do
    ticket_type
    |> cast(attrs, [:name, :description, :price, :number])
    |> validate_required([:name, :description, :price, :number])
    |> unique_constraint(:name)
  end
end
