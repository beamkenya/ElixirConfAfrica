defmodule ElixirConfAfrica.TicketTypesTest do
  use ElixirConfAfrica.DataCase

  alias ElixirConfAfrica.TicketTypes

  describe "ticket_types" do
    alias ElixirConfAfrica.TicketTypes.TicketType

    import ElixirConfAfrica.TicketTypesFixtures
    import ElixirConfAfrica.EventsFixtures

    @invalid_attrs %{name: nil, description: nil, price: nil, number: nil}

    test "list_ticket_types/0 returns all ticket_types" do
      event = event_fixture()
      ticket_type = ticket_type_fixture(%{event_id: event.id})
      assert TicketTypes.list_ticket_types() == [ticket_type]
    end

    test "get_ticket_type!/1 returns the ticket_type with given id" do
      event = event_fixture()
      ticket_type = ticket_type_fixture(%{event_id: event.id})

      assert TicketTypes.get_ticket_type!(ticket_type.id) == ticket_type
    end

    test "create_ticket_type/1 with valid data creates a ticket_type" do
      event = event_fixture()

      valid_attrs = %{
        event_id: event.id,
        name: "some name",
        description: "some description",
        price: "120.5",
        number: "357"
      }

      assert {:ok, %TicketType{} = ticket_type} = TicketTypes.create_ticket_type(valid_attrs)
      assert ticket_type.name == "some name"
      assert ticket_type.description == "some description"
      assert ticket_type.price == Decimal.new("120.5")
    end

    test "create_ticket_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TicketTypes.create_ticket_type(@invalid_attrs)
    end

    test "update_ticket_type/2 with valid data updates the ticket_type" do
      event = event_fixture()
      ticket_type = ticket_type_fixture(%{event_id: event.id})

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        price: "456.7",
        number: "579"
      }

      assert {:ok, %TicketType{} = ticket_type} =
               TicketTypes.update_ticket_type(ticket_type, update_attrs)

      assert ticket_type.name == "some updated name"
      assert ticket_type.description == "some updated description"
      assert ticket_type.price == Decimal.new("456.7")
      assert ticket_type.number == 579
    end

    test "update_ticket_type/2 with invalid data returns error changeset" do
      event = event_fixture()
      ticket_type = ticket_type_fixture(%{event_id: event.id})

      assert {:error, %Ecto.Changeset{}} =
               TicketTypes.update_ticket_type(ticket_type, @invalid_attrs)

      assert ticket_type == TicketTypes.get_ticket_type!(ticket_type.id)
    end

    test "delete_ticket_type/1 deletes the ticket_type" do
      event = event_fixture()
      ticket_type = ticket_type_fixture(%{event_id: event.id})

      assert {:ok, %TicketType{}} = TicketTypes.delete_ticket_type(ticket_type)
      assert_raise Ecto.NoResultsError, fn -> TicketTypes.get_ticket_type!(ticket_type.id) end
    end

    test "change_ticket_type/1 returns a ticket_type changeset" do
      event = event_fixture()
      ticket_type = ticket_type_fixture(%{event_id: event.id})
      assert %Ecto.Changeset{} = TicketTypes.change_ticket_type(ticket_type)
    end
  end
end
