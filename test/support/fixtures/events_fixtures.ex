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
end
