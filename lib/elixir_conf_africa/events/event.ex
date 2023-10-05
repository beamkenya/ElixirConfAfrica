defmodule ElixirConfAfrica.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :event_type, :string
    field :location, :string
    field :start_date, :naive_datetime
    field :end_date, :naive_datetime
    has_many :tickets, ElixirConfAfrica.Tickets.Ticket

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :start_date, :end_date, :event_type, :location])
    |> validate_required([:name, :start_date, :end_date, :event_type, :location])
  end
end
