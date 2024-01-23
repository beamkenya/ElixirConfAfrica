defmodule ElixirConfAfricaWeb.SuccessLiveTest do
  use ElixirConfAfricaWeb.ConnCase

  import Phoenix.LiveViewTest
  alias ElixirConfAfrica.Factory
  alias ElixirConfAfrica.Paystack

  describe "Tests the Success Redirect URL that you are redirected to" do
    setup do
      ticket_type = Factory.insert(:ticket_type, name: "some name", price: 400)

      %{"reference" => reference} =
        Paystack.initialize("michaelmunavu83@gmail.com", 400)

      Factory.insert(:ticket,
        is_paid: true,
        is_refunded: false,
        name: "some paid name",
        ticket_type_id: ticket_type.id,
        ticketid: reference
      )

      [
        reference: reference
      ]
    end

    test "you see a button to go back to the tickets page if the payment is not successful", %{
      reference: reference,
      conn: conn
    } do
      {:ok, _index_live, html} =
        live(conn, ~p"/success?trxref=#{reference}")

      assert html =~ "Payment was unsuccessful , go back to the tickets and purchase"
      assert html =~ "Back to Tickets Page"
    end

    test "the button for tickets page takes you back to the tickets page", %{
      reference: reference,
      conn: conn
    } do
      {:ok, index_live, _html} =
        live(conn, ~p"/success?trxref=#{reference}")

      {:ok, _index_live, html} =
        index_live
        |> element("a", "Back to Tickets Page")
        |> render_click()
        |> follow_redirect(conn)

      assert html =~ "Available Tickets"
    end
  end
end
