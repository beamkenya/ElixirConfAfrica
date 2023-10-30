defmodule ElixirConfAfrica.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias ElixirConfAfrica.Repo

  alias ElixirConfAfrica.Events.Event
  alias ElixirConfAfrica.TicketTypes.TicketType

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(from e in Event, order_by: [desc: e.id])
  end

  def get_elixir_conf_event_and_ticket_types do
    get_elixir_conf_event()
    |> Repo.preload(:ticket_types)
  end

  @spec get_elixir_conf_event() :: nil | Event.t()
  def get_elixir_conf_event do
    Repo.get_by(Event, name: "ElixirConf Africa 2024")
  end

  def get_all_available_tickets do
    query =
      from t in TicketType,
        join: e in Event,
        on: t.event_id == e.id and e.name == "ElixirConf Africa 2024",
        select: sum(t.number)

    Repo.one(query)
  end

  @spec get_event!(any()) :: any()
  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end
end
