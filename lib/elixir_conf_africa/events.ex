defmodule ElixirConfAfrica.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false

  alias ElixirConfAfrica.Events.Event
  alias ElixirConfAfrica.Repo
  alias ElixirConfAfrica.TicketTypes.TicketType

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  @spec list_events() :: list()
  def list_events do
    Repo.all(from e in Event, order_by: [desc: e.id])
  end

  @doc """
  Returns the elixir conf event together with all its ticket types
  """
  @spec get_event_with_ticket_types_by_event_name(String.t()) :: Event.t()
  def get_event_with_ticket_types_by_event_name(event_name) do
    query =
      from event in Event,
        join: ticket_types in assoc(event, :ticket_types),
        where: event.name == ^event_name,
        preload: [ticket_types: ticket_types]
    Repo.one(query)
  end

  @doc """
  Get totals number of available tickets for a given event
  """
  @spec get_total_number_of_available_tickets(String.t()) :: Event.t()
  def get_total_number_of_available_tickets(event_name) do
    query =
      from t in TicketType,
        join: e in Event,
        on: t.event_id == e.id and e.name == ^event_name,
        select: sum(t.number)

    Repo.one(query)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_event!(non_neg_integer()) :: Event.t() | Ecto.NoResultsError
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_event(map()) :: {:ok, Event.t()} | {:error, Ecto.Changeset.t()}
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
  @spec update_event(Event.t(), map()) :: {:ok, Event.t()} | {:error, Ecto.Changeset.t()}
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
  @spec delete_event(Event.t()) :: {:ok, Event.t()} | {:error, Ecto.Changeset.t()}
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  @spec change_event(Event.t(), map()) :: Ecto.Changeset.t()
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end
end
