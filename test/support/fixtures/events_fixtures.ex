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
        location: "some location",
        description: "some very long description",
        start_date: ~U[2023-10-03 11:14:00Z],
        end_date: ~U[2023-10-03 11:14:00Z],
        event_type: "some event_type"
      })
      |> ElixirConfAfrica.Events.create_event()

    event
  end
end
