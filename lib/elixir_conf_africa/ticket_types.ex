defmodule ElixirConfAfrica.TicketTypes do
  @moduledoc """
  The TicketTypes context.
  """

  import Ecto.Query, warn: false
  alias ElixirConfAfrica.Repo

  alias ElixirConfAfrica.TicketTypes.TicketType

  @doc """
  Returns the list of ticket_types.

  ## Examples

      iex> list_ticket_types()
      [%TicketType{}, ...]

  """
  @spec list_ticket_types() :: list()
  def list_ticket_types do
    Repo.all(TicketType)
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
  @spec get_ticket_type!(non_neg_integer()) :: TicketType.t() | Ecto.NoResultsError
  def get_ticket_type!(id), do: Repo.get!(TicketType, id)

  @doc """
  Creates a ticket_type.

  ## Examples

      iex> create_ticket_type(%{field: value})
      {:ok, %TicketType{}}

      iex> create_ticket_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_ticket_type(map()) :: {:ok, TicketType.t()} | {:error, Ecto.Changeset.t()}
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
  @spec update_ticket_type(TicketType.t(), map()) ::
          {:ok, TicketType.t()} | {:error, Ecto.Changeset.t()}
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
  @spec delete_ticket_type(TicketType.t()) :: {:ok, TicketType.t()} | {:error, Ecto.Changeset.t()}
  def delete_ticket_type(%TicketType{} = ticket_type) do
    Repo.delete(ticket_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket_type changes.

  ## Examples

      iex> change_ticket_type(ticket_type)
      %Ecto.Changeset{data: %TicketType{}}

  """
  @spec change_ticket_type(TicketType.t(), map()) :: Ecto.Changeset.t()
  def change_ticket_type(%TicketType{} = ticket_type, attrs \\ %{}) do
    TicketType.changeset(ticket_type, attrs)
  end
end
