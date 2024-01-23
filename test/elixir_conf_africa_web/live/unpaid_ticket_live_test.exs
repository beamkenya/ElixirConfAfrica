defmodule ElixirConfAfricaWeb.UnpaidTicketLiveTest do
  use ElixirConfAfricaWeb.ConnCase

  import Phoenix.LiveViewTest
  alias ElixirConfAfrica.Factory
  alias ElixirConfAfrica.Paystack

  describe "Unpaid Tickets Tests" do
    setup %{conn: conn} do
      # sign up first
      conn =
        post(conn, ~p"/users/register",
          method: :create,
          user: %{email: "admin@gmail.com", password: "123456", role: "admin"}
        )

      ticket_type = Factory.insert(:ticket_type, name: "some name", price: 400)

      %{"reference" => reference} =
        Paystack.initialize("michaelmunavu83@gmail.com", 400)

      paid_ticket =
        Factory.insert(:ticket,
          is_paid: true,
          is_refunded: false,
          name: "some paid name",
          ticketid: reference,
          ticket_type_id: ticket_type.id
        )

      %{"reference" => reference} =
        Paystack.initialize("michaelmunavu83@gmail.com", 400)

      unpaid_ticket =
        Factory.insert(:ticket,
          is_paid: false,
          is_refunded: false,
          name: "some unpaid name",
          ticketid: reference,
          ticket_type_id: ticket_type.id
        )

      [
        paid_ticket: paid_ticket,
        unpaid_ticket: unpaid_ticket,
        conn: conn
      ]
    end

    test "you see the unpaid tickets on /tickets/unpaid", %{
      conn: conn,
      paid_ticket: paid_ticket,
      unpaid_ticket: unpaid_ticket
    } do
      {:ok, _index_live, html} = live(conn, ~p"/tickets/unpaid")

      assert html =~ "Listing Unpaid Tickets"
      assert html =~ unpaid_ticket.name
      refute html =~ paid_ticket.name
    end
  end
end
