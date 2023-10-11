defmodule ElixirConfAfrica.TicketTypes.TicketType do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "ticket_types" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :number, :integer
    belongs_to :event, ElixirConfAfrica.Events.Event

    timestamps()
  end

  @doc false
  def changeset(ticket_type, attrs) do
    ticket_type
    |> cast(attrs, [:event_id, :name, :description, :price, :number])
    |> validate_required([:event_id, :name, :description, :price, :number])
    |> foreign_key_constraint(:event_id)
  end
end
