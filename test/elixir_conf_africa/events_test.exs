defmodule ElixirConfAfrica.EventsTest do
  @moduledoc false
  use ElixirConfAfrica.DataCase

  alias ElixirConfAfrica.Events

  describe "events" do
    import ElixirConfAfrica.Factory

    alias ElixirConfAfrica.Events.Event

    @invalid_attrs %{
      name: nil,
      description: nil,
      location: nil,
      event_type: nil,
      start_date: nil,
      end_date: nil
    }
    setup do
      event = insert!(:elixir_conf_event)
      [event: event]
    end

    test "list_events/0 returns all events", %{event: event} do
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id", %{event: event} do
      assert Events.get_event!(event.id) == event
    end

    test "get_event_with_ticket_types_by_event_name/1 returns the elixir conf event with ticket types",
         %{event: event} do
      ticket_type =
        insert!(:elixir_conf_ticket_type, event_id: event.id)

      event_with_ticket_types = ElixirConfAfrica.Repo.preload(event, :ticket_types)
      assert event = Events.get_event_with_ticket_types_by_event_name(event.name)

      assert event_with_ticket_types.ticket_types == [ticket_type]
      assert event == event_with_ticket_types
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        location: "some location",
        event_type: "some event_type",
        start_date: ~N[2023-10-05 06:18:00],
        end_date: ~N[2023-10-05 06:18:00]
      }

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.name == "some name"
      assert event.description == "some description"
      assert event.location == "some location"
      assert event.event_type == "some event_type"
      assert event.start_date == ~N[2023-10-05 06:18:00]
      assert event.end_date == ~N[2023-10-05 06:18:00]
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event", %{event: event} do
      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        location: "some updated location",
        event_type: "some updated event_type",
        start_date: ~N[2023-10-06 06:18:00],
        end_date: ~N[2023-10-06 06:18:00]
      }

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.name == "some updated name"
      assert event.description == "some updated description"
      assert event.location == "some updated location"
      assert event.event_type == "some updated event_type"
      assert event.start_date == ~N[2023-10-06 06:18:00]
      assert event.end_date == ~N[2023-10-06 06:18:00]
    end

    test "update_event/2 with invalid data returns error changeset", %{event: event} do
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event", %{event: event} do
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset", %{event: event} do
      assert %Ecto.Changeset{} = Events.change_event(event)
    end

    test "get_total_number_of_available_tickets/1 returns total number of tickets", %{
      event: event
    } do
      %{number: number} = insert!(:elixir_conf_ticket_type, event_id: event.id)
      %{number: number1} = insert!(:elixir_conf_ticket_type, event_id: event.id)
      total_number_of_available_tickets = number1 + number

      assert Events.get_total_number_of_available_tickets(event.name) ==
               total_number_of_available_tickets
    end
  end
end
