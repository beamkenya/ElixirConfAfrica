defmodule ElixirConfAfrica.TicketTypes do
  @moduledoc """
  The TicketTypes context.
  """

  import Ecto.Query, warn: false
  alias ElixirConfAfrica.Repo

  alias ElixirConfAfrica.TicketTypes.TicketType
  alias ElixirConfAfrica.Tickets.Ticket

  @doc """
  Returns the list of ticket_types.

  ## Examples

      iex> list_ticket_types()
      [%TicketType{}, ...]

  """
  def list_ticket_types do
    Repo.all(TicketType)
  end

  @doc """
  Returns the list of ticket_types with the remaining tickets.


  """

  def list_ticket_types_with_remaining_tickets do
    from(tick in TicketType,
      left_join: t in Ticket,
      on: t.ticket_type_id == tick.id and t.is_paid == true and t.is_refunded == false,
      group_by: tick.id,
      select: %{
        id: tick.id,
        name: tick.name,
        remaining_tickets: coalesce(tick.number - count(t.id), 0),
        description: tick.description,
        price: tick.price
      }
    )
    |> Repo.all()
  end

  @doc """
  Gets a single ticket_type.

  Raises `Ecto.NoResultsError` if the Ticket type does not exist.

  ## Examples

      iex> get_ticket_type!(123)
      %TicketType{}

      iex> get_ticket_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ticket_type!(id), do: Repo.get!(TicketType, id)

  @doc """
  Creates a ticket_type.

  ## Examples

      iex> create_ticket_type(%{field: value})
      {:ok, %TicketType{}}

      iex> create_ticket_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ticket_type(attrs \\ %{}) do
    %TicketType{}
    |> TicketType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ticket_type.

  ## Examples

      iex> update_ticket_type(ticket_type, %{field: new_value})
      {:ok, %TicketType{}}

      iex> update_ticket_type(ticket_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ticket_type(%TicketType{} = ticket_type, attrs) do
    ticket_type
    |> TicketType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ticket_type.

  ## Examples

      iex> delete_ticket_type(ticket_type)
      {:ok, %TicketType{}}

      iex> delete_ticket_type(ticket_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ticket_type(%TicketType{} = ticket_type) do
    Repo.delete(ticket_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket_type changes.

  ## Examples

      iex> change_ticket_type(ticket_type)
      %Ecto.Changeset{data: %TicketType{}}

  """
  def change_ticket_type(%TicketType{} = ticket_type, attrs \\ %{}) do
    TicketType.changeset(ticket_type, attrs)
  end
end
