defmodule ElixirConfAfrica.TicketsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirConfAfrica.Tickets` context.
  """

  @doc """
  Generate a ticket.
  """
  def ticket_fixture(attrs \\ %{}) do
    {:ok, ticket} =
      attrs
      |> Enum.into(%{
        type: "some type",
        description: "some description",
        price: "143.7",
        ticket_number: 42
      })
      |> ElixirConfAfrica.Tickets.create_ticket()

    ticket
  end
end
