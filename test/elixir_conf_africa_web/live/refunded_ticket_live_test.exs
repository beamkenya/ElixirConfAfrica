defmodule ElixirConfAfricaWeb.RefundedTicketLiveTest do
  use ElixirConfAfricaWeb.ConnCase

  import Phoenix.LiveViewTest
  alias ElixirConfAfrica.Factory

  describe "Refunded Tickets Tests" do
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

      refunded_ticket =
        Factory.insert(:ticket,
          is_paid: true,
          is_refunded: true,
          name: "some refunded name",
          ticket_type_id: ticket_type.id
        )

      [
        paid_ticket: paid_ticket,
        refunded_ticket: refunded_ticket,
        conn: conn
      ]
    end

    test "you see the refunded tickets on /tickets/refunded", %{
      conn: conn,
      paid_ticket: paid_ticket,
      refunded_ticket: refunded_ticket
    } do
      {:ok, _index_live, html} = live(conn, ~p"/tickets/refunded")

      assert html =~ "Listing Refunded Tickets"
      assert html =~ refunded_ticket.name
      refute html =~ paid_ticket.name
    end
  end
end
