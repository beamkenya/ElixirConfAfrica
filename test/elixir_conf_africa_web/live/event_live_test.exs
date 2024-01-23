defmodule ElixirConfAfricaWeb.EventLiveTest do
  use ElixirConfAfricaWeb.ConnCase

  import Phoenix.LiveViewTest
  alias ElixirConfAfrica.Factory

  @valid_attributes %{
    name: "some name",
    email: "michaelmunavu83@gmail.com",
    quantity: 2
  }

  @invalid_attributes %{
    name: nil,
    email: nil,
    quantity: 2
  }

  describe "Event" do
    setup do
      ticket_type1 = Factory.insert(:ticket_type, number: 10, name: "Early Bird", price: 400)
      ticket_type2 = Factory.insert(:ticket_type, number: 10, name: "Advanced", price: 500)

      Factory.insert(:ticket,
        ticket_type_id: ticket_type1.id,
        is_paid: false,
        is_refunded: false,
        cost: 400
      )

      Factory.insert(:ticket,
        ticket_type_id: ticket_type2.id,
        is_paid: true,
        is_refunded: false,
        cost: 400
      )

      Factory.insert(:ticket,
        ticket_type_id: ticket_type1.id,
        is_paid: true,
        is_refunded: false,
        cost: 400
      )

      Factory.insert(:ticket,
        ticket_type_id: ticket_type2.id,
        is_paid: true,
        is_refunded: true,
        cost: 400
      )

      %{ticket_type1: ticket_type1, ticket_type2: ticket_type2}
    end

    test "You can see available tickets with their remaining quantity", %{
      conn: conn,
      ticket_type1: ticket_type1,
      ticket_type2: ticket_type2
    } do
      {:ok, _index_live, html} = live(conn, ~p"/event")

      assert html =~ ticket_type1.name
      assert html =~ ticket_type2.name
      assert html =~ "9"
      assert html =~ "8"
    end

    test "once you click on get ticket for a  particular ticket type , a form popups where you add your details",
         %{
           conn: conn,
           ticket_type1: ticket_type1
         } do
      {:ok, index_live, _html} = live(conn, ~p"/event")

      index_live
      |> element("#buy-#{ticket_type1.id}-tickets", "Get")
      |> render_click()

      assert_patch(index_live, ~p"/event/#{ticket_type1.id}/buy")

      assert has_element?(index_live, "#ticket-form")
    end

    test "adding invalid data on the form renders errors",
         %{
           conn: conn,
           ticket_type1: ticket_type1
         } do
      {:ok, index_live, _html} = live(conn, ~p"/event")

      index_live
      |> element("#buy-#{ticket_type1.id}-tickets", "Get")
      |> render_click()

      {:ok, index_live, _html} =
        live(conn, ~p"/event/#{ticket_type1.id}/buy")

      assert index_live
             |> form("#ticket-form", ticket: @invalid_attributes)
             |> render_change() =~ "can&#39;t be blank"
    end

    test "adding valid data on the form redirects to the event page",
         %{
           conn: conn,
           ticket_type1: ticket_type1
         } do
      {:ok, index_live, _html} = live(conn, ~p"/event")

      index_live
      |> element("#buy-#{ticket_type1.id}-tickets", "Get")
      |> render_click()

      index_live
      |> form("#ticket-form", ticket: @valid_attributes)
      |> render_submit()
    end
  end
end
