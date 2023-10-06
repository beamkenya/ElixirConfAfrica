defmodule ElixirConfAfrica.TicketsTest do
  use ElixirConfAfrica.DataCase

  alias ElixirConfAfrica.Tickets

  describe "tickets" do
    alias ElixirConfAfrica.Tickets.Ticket

    import ElixirConfAfrica.{TicketsFixtures, EventsFixtures}

    @invalid_attrs %{type: nil, description: nil, price: nil, ticket_number: nil}

    test "list_tickets/0 returns all tickets" do
      event = event_fixture()
      ticket = ticket_fixture(%{event_id: event.id})
      assert Tickets.list_tickets() == [ticket]
    end

    test "get_ticket!/1 returns the ticket with given id" do
      event = event_fixture()
      ticket = ticket_fixture(%{event_id: event.id})
      assert Tickets.get_ticket!(ticket.id) == ticket
    end

    test "create_ticket/1 with valid data creates a ticket" do
      event = event_fixture()

      valid_attrs = %{
        event_id: event.id,
        type: "some type",
        description: "some description",
        price: "133.4",
        ticket_number: 42
      }

      assert {:ok, %Ticket{} = ticket} = Tickets.create_ticket(valid_attrs)
      assert ticket.type == "some type"
      assert ticket.description == "some description"
      assert ticket.price == Decimal.new("133.4")
      assert ticket.ticket_number == 42
    end

    test "create_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tickets.create_ticket(@invalid_attrs)
    end

    test "update_ticket/2 with valid data updates the ticket" do
      event = event_fixture()
      ticket = ticket_fixture(%{event_id: event.id})

      update_attrs = %{
        type: "some updated type",
        description: "some updated description",
        price: "543.9",
        ticket_number: 43
      }

      assert {:ok, %Ticket{} = ticket} = Tickets.update_ticket(ticket, update_attrs)
      assert ticket.type == "some updated type"
      assert ticket.description == "some updated description"
      assert ticket.price == Decimal.new("543.9")
      assert ticket.ticket_number == 43
    end

    test "update_ticket/2 with invalid data returns error changeset" do
      event = event_fixture()
      ticket = ticket_fixture(%{event_id: event.id})
      assert {:error, %Ecto.Changeset{}} = Tickets.update_ticket(ticket, @invalid_attrs)
      assert ticket == Tickets.get_ticket!(ticket.id)
    end

    test "delete_ticket/1 deletes the ticket" do
      event = event_fixture()
      ticket = ticket_fixture(%{event_id: event.id})
      assert {:ok, %Ticket{}} = Tickets.delete_ticket(ticket)
      assert_raise Ecto.NoResultsError, fn -> Tickets.get_ticket!(ticket.id) end
    end

    test "change_ticket/1 returns a ticket changeset" do
      event = event_fixture()
      ticket = ticket_fixture(%{event_id: event.id})
      assert %Ecto.Changeset{} = Tickets.change_ticket(ticket)
    end
  end
end
