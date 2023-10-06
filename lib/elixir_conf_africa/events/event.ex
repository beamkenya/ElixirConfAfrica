defmodule ElixirConfAfrica.Events.Event do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :description, :string
    field :location, :string
    field :event_type, :string
    field :start_date, :naive_datetime
    field :end_date, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :event_type, :location, :description, :start_date, :end_date])
    |> validate_required([:name, :event_type, :location, :description, :start_date, :end_date])
  end
end
