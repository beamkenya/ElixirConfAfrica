defmodule ElixirConfAfrica.TicketTypesTest do
  use ElixirConfAfrica.DataCase

  alias ElixirConfAfrica.TicketTypes

  describe "ticket_types" do
    import ElixirConfAfrica.Factory

    alias ElixirConfAfrica.TicketTypes.TicketType

    @invalid_attrs %{name: nil, description: nil, price: nil, number: nil}
    setup do
      event = insert!(:elixir_conf_event)
      ticket_type = insert!(:elixir_conf_ticket_type, event_id: event.id)
      %{ticket_type: ticket_type, event: event}
    end

    test "list_ticket_types/0 returns all ticket_types", %{ticket_type: ticket_type} do
      assert [^ticket_type] = TicketTypes.list_ticket_types()
    end

    test "get_ticket_type!/1 returns the ticket_type with given id", %{ticket_type: ticket_type} do
      assert ^ticket_type = TicketTypes.get_ticket_type!(ticket_type.id)
    end

    test "create_ticket_type/1 with valid data creates a ticket_type", %{event: event} do
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

    test "update_ticket_type/2 with valid data updates the ticket_type", %{
      ticket_type: ticket_type
    } do
      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        price: "456.7",
        number: "579"
      }

      assert {:ok, %TicketType{} = update_ticket_type} =
               TicketTypes.update_ticket_type(ticket_type, update_attrs)

      refute ticket_type == update_ticket_type
      assert update_ticket_type.name == "some updated name"
      assert update_ticket_type.description == "some updated description"
      assert update_ticket_type.price == Decimal.new("456.7")
      assert update_ticket_type.number == 579
    end

    test "update_ticket_type/2 with invalid data returns error changeset", %{
      ticket_type: ticket_type
    } do
      assert {:error, %Ecto.Changeset{}} =
               TicketTypes.update_ticket_type(ticket_type, @invalid_attrs)

      assert ^ticket_type = TicketTypes.get_ticket_type!(ticket_type.id)
    end

    test "delete_ticket_type/1 deletes the ticket_type", %{ticket_type: ticket_type} do
      assert {:ok, %TicketType{}} = TicketTypes.delete_ticket_type(ticket_type)
      assert_raise Ecto.NoResultsError, fn -> TicketTypes.get_ticket_type!(ticket_type.id) end
    end

    test "change_ticket_type/1 returns a ticket_type changeset", %{ticket_type: ticket_type} do
      assert %Ecto.Changeset{} = TicketTypes.change_ticket_type(ticket_type)
    end
  end
end
