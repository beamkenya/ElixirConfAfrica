defmodule ElixirConfAfrica.TicketsTest do
  use ElixirConfAfrica.DataCase

  alias ElixirConfAfrica.Tickets

  describe "tickets" do
    alias ElixirConfAfrica.Tickets.Ticket

    import ElixirConfAfrica.TicketsFixtures

    @invalid_attrs %{type: nil, description: nil, price: nil, ticket_number: nil}

    test "list_tickets/0 returns all tickets" do
      ticket = ticket_fixture()
      assert Tickets.list_tickets() == [ticket]
    end

    test "get_ticket!/1 returns the ticket with given id" do
      ticket = ticket_fixture()
      assert Tickets.get_ticket!(ticket.id) == ticket
    end

    test "create_ticket/1 with valid data creates a ticket" do
      valid_attrs = %{
        type: "some type",
        description: "some description",
        price: 42,
        ticket_number: 42
      }

      assert {:ok, %Ticket{} = ticket} = Tickets.create_ticket(valid_attrs)
      assert ticket.type == "some type"
      assert ticket.description == "some description"
      assert ticket.price == 42
      assert ticket.ticket_number == 42
    end

    test "create_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tickets.create_ticket(@invalid_attrs)
    end

    test "update_ticket/2 with valid data updates the ticket" do
      ticket = ticket_fixture()

      update_attrs = %{
        type: "some updated type",
        description: "some updated description",
        price: 43,
        ticket_number: 43
      }

      assert {:ok, %Ticket{} = ticket} = Tickets.update_ticket(ticket, update_attrs)
      assert ticket.type == "some updated type"
      assert ticket.description == "some updated description"
      assert ticket.price == 43
      assert ticket.ticket_number == 43
    end

    test "update_ticket/2 with invalid data returns error changeset" do
      ticket = ticket_fixture()
      assert {:error, %Ecto.Changeset{}} = Tickets.update_ticket(ticket, @invalid_attrs)
      assert ticket == Tickets.get_ticket!(ticket.id)
    end

    test "delete_ticket/1 deletes the ticket" do
      ticket = ticket_fixture()
      assert {:ok, %Ticket{}} = Tickets.delete_ticket(ticket)
      assert_raise Ecto.NoResultsError, fn -> Tickets.get_ticket!(ticket.id) end
    end

    test "change_ticket/1 returns a ticket changeset" do
      ticket = ticket_fixture()
      assert %Ecto.Changeset{} = Tickets.change_ticket(ticket)
    end
  end
end
