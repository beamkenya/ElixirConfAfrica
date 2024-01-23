defmodule ElixirConfAfricaWeb.TicketShowLiveTest do
  use ElixirConfAfricaWeb.ConnCase

  import Phoenix.LiveViewTest
  alias ElixirConfAfrica.Factory

  describe "Tests The Ticket Show Page" do
    setup do
      ticket_type = Factory.insert(:ticket_type, name: "some name", price: 400)

      ticket =
        Factory.insert(:ticket,
          is_paid: true,
          is_refunded: false,
          name: "some paid name",
          ticket_type_id: ticket_type.id,
          ticketid: "some-ticket-id"
        )

      [
        ticket: ticket
      ]
    end

    test "you see the ticket details on /tickets/:id", %{ticket: ticket, conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/tickets/#{ticket.ticketid}")

      assert html =~ ticket.name
      assert html =~ ticket.email
    end

    test "you see a qr code on the ticket show page", %{ticket: ticket, conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tickets/#{ticket.ticketid}")

      assert has_element?(index_live, "#qrcode")
    end
  end
end
