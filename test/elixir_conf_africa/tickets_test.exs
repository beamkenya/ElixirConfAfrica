defmodule ElixirConfAfrica.TicketsTest do
  use ElixirConfAfrica.DataCase

  alias ElixirConfAfrica.Factory
  alias ElixirConfAfrica.Tickets
  alias ElixirConfAfrica.Tickets.Ticket

  describe "ticket" do
    @invalid_attrs %{name: nil, email: nil, ticketid: nil, quantity: nil}

    setup do
      ticket_type = Factory.insert(:ticket_type, number: 10)

      ticket =
        Factory.insert(:ticket,
          ticket_type_id: ticket_type.id,
          is_paid: true,
          is_refunded: false,
          cost: 400
        )

      unpaid_ticket =
        Factory.insert(:ticket,
          ticket_type_id: ticket_type.id,
          is_paid: false,
          is_refunded: false,
          cost: 400
        )

      refunded_ticket =
        Factory.insert(:ticket,
          ticket_type_id: ticket_type.id,
          is_paid: true,
          is_refunded: true,
          cost: 400
        )

      [
        ticket_type: ticket_type,
        ticket: ticket,
        unpaid_ticket: unpaid_ticket,
        refunded_ticket: refunded_ticket
      ]
    end

    test "list_ticket/0 returns all ticket", %{
      ticket: ticket,
      unpaid_ticket: unpaid_ticket,
      refunded_ticket: refunded_ticket
    } do
      assert Tickets.list_ticket() == [ticket, unpaid_ticket, refunded_ticket]
    end

    test "list_paid_tickets/0 returns all paid tickets that are not refunded", %{
      ticket: ticket,
      ticket_type: ticket_type
    } do
      assert Tickets.list_paid_tickets() == [
               ticket |> Map.put(:ticket_type, ticket_type)
             ]
    end

    test "list_unpaid_tickets/0 returns all unpaid tickets that are not refunded", %{
      unpaid_ticket: unpaid_ticket,
      ticket_type: ticket_type
    } do
      assert Tickets.list_unpaid_tickets() == [
               unpaid_ticket |> Map.put(:ticket_type, ticket_type)
             ]
    end

    test "list_refunded_tickets/0 returns all refunded tickets that are paid", %{
      refunded_ticket: refunded_ticket,
      ticket_type: ticket_type
    } do
      assert Tickets.list_refunded_tickets() == [
               refunded_ticket |> Map.put(:ticket_type, ticket_type)
             ]
    end

    test "get_ticket!/1 returns the ticket with given id", %{ticket: ticket} do
      assert Tickets.get_ticket!(ticket.id) == ticket
    end

    test "get_ticket_by_ticketid!/1 returns the ticket with given ticketid", %{
      ticket: ticket,
      ticket_type: ticket_type
    } do
      assert Tickets.get_ticket_by_ticketid!(ticket.ticketid) ==
               ticket |> Map.put(:ticket_type, ticket_type)
    end

    test "create_ticket/1 with valid data creates a ticket", %{
      ticket_type: ticket_type
    } do
      valid_attrs = %{
        name: "some name",
        email: "email@gmail.com",
        ticketid: "some ticketid",
        quantity: 42,
        ticket_type_id: ticket_type.id,
        cost: 200
      }

      assert {:ok, %Ticket{} = ticket} = Tickets.create_ticket(valid_attrs)
      assert ticket.name == "some name"
      assert ticket.email == "email@gmail.com"
      assert ticket.ticketid == "some ticketid"
      assert ticket.quantity == 42
    end

    test "create_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tickets.create_ticket(@invalid_attrs)
    end

    test "update_ticket/2 with valid data updates the ticket", %{
      ticket_type: ticket_type,
      ticket: ticket
    } do
      update_attrs = %{
        name: "some updated name",
        email: "someemail@gmail.com",
        ticketid: "some updated ticketid",
        quantity: 43,
        cost: 200,
        ticket_type_id: ticket_type.id
      }

      assert {:ok, %Ticket{} = ticket} = Tickets.update_ticket(ticket, update_attrs)
      assert ticket.name == "some updated name"
      assert ticket.email == "someemail@gmail.com"
      assert ticket.ticketid == "some updated ticketid"
      assert ticket.quantity == 43
    end

    test "update_ticket/2 with invalid data returns error changeset", %{ticket: ticket} do
      assert {:error, %Ecto.Changeset{}} = Tickets.update_ticket(ticket, @invalid_attrs)
      assert ticket == Tickets.get_ticket!(ticket.id)
    end

    test "delete_ticket/1 deletes the ticket", %{ticket: ticket} do
      assert {:ok, %Ticket{}} = Tickets.delete_ticket(ticket)
    end

    test "change_ticket/1 returns a ticket changeset", %{ticket: ticket} do
      assert %Ecto.Changeset{} = Tickets.change_ticket(ticket)
    end
  end
end
