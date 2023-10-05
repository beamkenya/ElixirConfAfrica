defmodule ElixirConfAfrica.EventsTest do
  use ElixirConfAfrica.DataCase

  alias ElixirConfAfrica.Events

  describe "events" do
    alias ElixirConfAfrica.Events.Event

    import ElixirConfAfrica.EventsFixtures

    @invalid_attrs %{name: nil, location: nil, start_date: nil, end_date: nil, event_type: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
        name: "some name",
        location: "some location",
        start_date: ~N[2023-10-03 11:14:00],
        end_date: ~N[2023-10-03 11:14:00],
        event_type: "some event_type"
      }

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.name == "some name"
      assert event.location == "some location"
      assert event.start_date == ~N[2023-10-03 11:14:00]
      assert event.end_date == ~N[2023-10-03 11:14:00]
      assert event.event_type == "some event_type"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        location: "some updated location",
        start_date: ~N[2023-10-04 11:14:00],
        end_date: ~N[2023-10-04 11:14:00],
        event_type: "some updated event_type"
      }

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.location == "some updated location"
      assert event.start_date == ~N[2023-10-04 11:14:00]
      assert event.end_date == ~N[2023-10-04 11:14:00]
      assert event.event_type == "some updated event_type"
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
