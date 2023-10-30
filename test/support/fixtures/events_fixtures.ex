defmodule ElixirConfAfrica.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirConfAfrica.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description",
        location: "some location",
        event_type: "some event_type",
        start_date: ~N[2023-10-05 06:18:00],
        end_date: ~N[2023-10-05 06:18:00]
      })
      |> ElixirConfAfrica.Events.create_event()

    event
  end

  def elixir_conf_event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: "ElixirConf Africa 2024",
        description: "some description",
        location: "some location",
        event_type: "some event_type",
        start_date: ~N[2023-10-05 06:18:00],
        end_date: ~N[2023-10-05 06:18:00]
      })
      |> ElixirConfAfrica.Events.create_event()

    event
  end

  def elixir_conf_event_with_tickets_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: "ElixirConf Africa 2024",
        description: "some description",
        location: "some location",
        event_type: "some event_type",
        start_date: ~N[2023-10-05 06:18:00],
        end_date: ~N[2023-10-05 06:18:00]
      })
      |> ElixirConfAfrica.Events.create_event()

    {:ok, ticket_type} =
      attrs
      |> Enum.into(%{
        event_id: event.id,
        name: "some name",
        description: "some description",
        price: "120.5",
        number: "357"
      })
      |> ElixirConfAfrica.TicketTypes.create_ticket_type()

    [event, ticket_type]
  end
end
