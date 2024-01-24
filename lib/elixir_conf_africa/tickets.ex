defmodule ElixirConfAfrica.Tickets do
  @moduledoc """
  The Tickets context.
  """

  import Ecto.Query, warn: false
  alias ElixirConfAfrica.Repo

  alias ElixirConfAfrica.Tickets.Ticket

  @doc """
  Returns the list of ticket.

  ## Examples

      iex> list_ticket()
      [%Ticket{}, ...]

  """
  def list_ticket do
    Repo.all(Ticket)
  end

  @doc """
  Gets a single ticket by ticketid.

  """

  def get_ticket_by_ticketid!(ticketid) do
    Ticket
    |> Repo.get_by!(ticketid: ticketid)
    |> Repo.preload(:ticket_type)
  end

  @doc """
  List paid tickets.

  """
  def list_paid_tickets do
    from(t in Ticket,
      where: t.is_paid and t.is_refunded == false,
      select: t,
      preload: [:ticket_type]
    )
    |> Repo.paginate()
  end

  @doc """
  List refunded tickets.

  """
  def list_refunded_tickets do
    from(t in Ticket,
      where: t.is_refunded,
      select: t,
      preload: [:ticket_type]
    )
    |> Repo.paginate()
  end

  @doc """
  List unpaid tickets.

  """

  def list_unpaid_tickets do
    from(t in Ticket,
      where: t.is_paid == false and t.is_refunded == false,
      left_join: type in assoc(t, :ticket_type),
      on: type.id == t.ticket_type_id,
      select: %{
        id: t.id,
        name: t.name,
        email: t.email,
        quantity: t.quantity,
        phone_number: t.phone_number,
        cost: t.cost,
        ticketid: t.ticketid,
        ticket_type_id: t.ticket_type_id,
        is_paid: t.is_paid,
        is_refunded: t.is_refunded,
        ticket_type: type
      }
    )
    |> Repo.paginate()
  end

  @doc """
  Gets a single ticket.

  Raises `Ecto.NoResultsError` if the Ticket does not exist.

  ## Examples

      iex> get_ticket!(123)
      %Ticket{}

      iex> get_ticket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ticket!(id), do: Repo.get!(Ticket, id)

  @doc """
  Creates a ticket.

  ## Examples

      iex> create_ticket(%{field: value})
      {:ok, %Ticket{}}

      iex> create_ticket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ticket(attrs \\ %{}) do
    %Ticket{}
    |> Ticket.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ticket.

  ## Examples

      iex> update_ticket(ticket, %{field: new_value})
      {:ok, %Ticket{}}

      iex> update_ticket(ticket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ticket(%Ticket{} = ticket, attrs) do
    ticket
    |> Ticket.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ticket.

  ## Examples

      iex> delete_ticket(ticket)
      {:ok, %Ticket{}}

      iex> delete_ticket(ticket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ticket(%Ticket{} = ticket) do
    Repo.delete(ticket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket changes.

  ## Examples

      iex> change_ticket(ticket)
      %Ecto.Changeset{data: %Ticket{}}

  """
  def change_ticket(%Ticket{} = ticket, attrs \\ %{}) do
    Ticket.changeset(ticket, attrs)
  end
end
