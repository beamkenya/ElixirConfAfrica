defmodule ElixirConfAfrica.TicketTypesTest do
  use ElixirConfAfrica.DataCase

  alias ElixirConfAfrica.Factory

  describe "ticket_types" do
    alias ElixirConfAfrica.TicketTypes
    alias ElixirConfAfrica.TicketTypes.TicketType

    @invalid_attrs %{name: nil, description: nil, price: nil}

    test "list_ticket_types/0 returns all ticket_types" do
      ticket_type = Factory.insert(:ticket_type)

      assert TicketTypes.list_ticket_types() == [ticket_type]
    end

    test "get_ticket_type!/1 returns the ticket_type with given id" do
      ticket_type = Factory.insert(:ticket_type)
      assert TicketTypes.get_ticket_type!(ticket_type.id) == ticket_type
    end

    test "create_ticket_type/1 with valid data creates a ticket_type" do
      valid_attrs = %{name: "some name", description: "some description", price: 42, number: 49}

      assert {:ok, %TicketType{} = ticket_type} = TicketTypes.create_ticket_type(valid_attrs)
      assert ticket_type.name == "some name"
      assert ticket_type.description == "some description"
      assert ticket_type.price == 42
    end

    test "create_ticket_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TicketTypes.create_ticket_type(@invalid_attrs)
    end

    test "update_ticket_type/2 with valid data updates the ticket_type" do
      ticket_type = Factory.insert(:ticket_type)

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        price: 43,
        number: 49
      }

      assert {:ok, %TicketType{} = ticket_type} =
               TicketTypes.update_ticket_type(ticket_type, update_attrs)

      assert ticket_type.name == "some updated name"
      assert ticket_type.description == "some updated description"
      assert ticket_type.price == 43
    end

    test "update_ticket_type/2 with invalid data returns error changeset" do
      ticket_type = Factory.insert(:ticket_type)

      assert {:error, %Ecto.Changeset{}} =
               TicketTypes.update_ticket_type(ticket_type, @invalid_attrs)

      assert ticket_type == TicketTypes.get_ticket_type!(ticket_type.id)
    end

    test "delete_ticket_type/1 deletes the ticket_type" do
      ticket_type = Factory.insert(:ticket_type)
      assert {:ok, %TicketType{}} = TicketTypes.delete_ticket_type(ticket_type)
      assert_raise Ecto.NoResultsError, fn -> TicketTypes.get_ticket_type!(ticket_type.id) end
    end

    test "change_ticket_type/1 returns a ticket_type changeset" do
      ticket_type = Factory.insert(:ticket_type)
      assert %Ecto.Changeset{} = TicketTypes.change_ticket_type(ticket_type)
    end

    test "list_ticket_types_with_remaining_tickets/0 returns all ticket_types with the remaining tickets available" do
      ticket_type = Factory.insert(:ticket_type, number: 10)

      Factory.insert(:ticket, ticket_type_id: ticket_type.id, is_paid: true)

      assert TicketTypes.list_ticket_types_with_remaining_tickets() ==
               [
                 %{
                   id: ticket_type.id,
                   name: ticket_type.name,
                   remaining_tickets: 9,
                   description: ticket_type.description,
                   price: ticket_type.price
                 }
               ]
    end
  end
end
