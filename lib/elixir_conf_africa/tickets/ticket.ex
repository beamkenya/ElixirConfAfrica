defmodule ElixirConfAfrica.Tickets.Ticket do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :type, :string
    field :description, :string
    field :price, :integer
    field :ticket_number, :integer
    belongs_to :event, ElixirConfAfrica.Events.Event

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:type, :description, :price, :ticket_number, :event_id])
    |> validate_required([:type, :description, :price, :ticket_number, :event_id])
    |> foreign_key_constraint(:event_id)
  end
end
