defmodule ElixirConfAfricaWeb.PaidTicketLiveTest do
  use ElixirConfAfricaWeb.ConnCase

  import Phoenix.LiveViewTest
  alias ElixirConfAfrica.Factory

  describe "Paid Tickets Tests" do
    setup %{conn: conn} do
      # sign up first
      conn =
        post(conn, ~p"/users/register",
          method: :create,
          user: %{email: "admin@gmail.com", password: "123456", role: "admin"}
        )

      ticket_type = Factory.insert(:ticket_type, name: "some name", price: 400)

      paid_ticket =
        Factory.insert(:ticket,
          is_paid: true,
          is_refunded: false,
          name: "some paid name",
          ticket_type_id: ticket_type.id
        )

      unpaid_ticket =
        Factory.insert(:ticket,
          is_paid: false,
          is_refunded: false,
          name: "some unpaid name",
          ticket_type_id: ticket_type.id
        )

      [
        paid_ticket: paid_ticket,
        unpaid_ticket: unpaid_ticket,
        conn: conn
      ]
    end

    test "you see the paid tickets on /tickets/paid", %{
      conn: conn,
      paid_ticket: paid_ticket,
      unpaid_ticket: unpaid_ticket
    } do
      {:ok, _index_live, html} = live(conn, ~p"/tickets/paid")

      assert html =~ "Listing Paid Tickets"
      assert html =~ paid_ticket.name
      refute html =~ unpaid_ticket.name
    end

    test "you see a button on each record that sends a ticket email", %{
      conn: conn,
      paid_ticket: paid_ticket
    } do
      {:ok, index_live, html} = live(conn, ~p"/tickets/paid")

      assert html =~ "Listing Paid Tickets"
      assert html =~ paid_ticket.name

      assert index_live
             |> element("#send-email-#{paid_ticket.id}", "Send Email")
             |> render_click() =~ "Ticket sent successfully"
    end
  end
end
