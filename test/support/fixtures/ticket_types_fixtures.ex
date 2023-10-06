defmodule ElixirConfAfrica.TicketTypesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirConfAfrica.TicketTypes` context.
  """

  @doc """
  Generate a ticket_type.
  """
  def ticket_type_fixture(attrs \\ %{}) do
    {:ok, ticket_type} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description",
        price: "120.5"
      })
      |> ElixirConfAfrica.TicketTypes.create_ticket_type()

    ticket_type
  end
end
