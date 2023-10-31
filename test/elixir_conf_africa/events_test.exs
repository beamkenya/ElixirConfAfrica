defmodule ElixirConfAfrica.EventsTest do
  use ElixirConfAfrica.DataCase

  alias ElixirConfAfrica.Events

  describe "events" do
    alias ElixirConfAfrica.Events.Event

    import ElixirConfAfrica.EventsFixtures

    import ElixirConfAfrica.Factory

    @invalid_attrs %{
      name: nil,
      description: nil,
      location: nil,
      event_type: nil,
      start_date: nil,
      end_date: nil
    }

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_elixir_conf_event /0 returns the elixir conf event" do
      event =
        insert!(:elixir_conf_event)

      assert Events.get_elixir_conf_event().name == event.name
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "get_elixir_conf_event_and_ticket_types/0 returns the elixir conf event with ticket types" do
      event =
        insert!(:elixir_conf_event)

      _ticket_type =
        insert!(:elixir_conf_ticket_type, event_id: event.id)

      assert Events.get_elixir_conf_event_and_ticket_types().ticket_types != []
    end

    test "get_all_available_tickets/0 returns the number of available tickets" do
      event =
        insert!(:elixir_conf_event)

      ticket_type =
        insert!(:elixir_conf_ticket_type, event_id: event.id)

      assert Events.get_number_of_tickets_available_for_elixir_conf_2024() == ticket_type.number
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

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

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

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
