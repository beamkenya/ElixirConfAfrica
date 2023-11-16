defmodule ElixirConfAfricaWeb.HomeLiveTest do
  use ElixirConfAfricaWeb.ConnCase

  import Phoenix.LiveViewTest
  import ElixirConfAfrica.Factory

  setup do
    event = insert!(:elixir_conf_event)
    ticket_type = insert!(:elixir_conf_ticket_type, event_id: event.id)
    %{ticket_type: ticket_type, event: event}
  end

  describe "Home Index" do
    test "Displays the elixir conf website details", %{conn: conn, event: event} do
      {:ok, _index_live, html} = live(conn, ~p"/home")

      assert html =~ "Event Information"
      assert html =~ event.name
      assert html =~ event.description
      assert html =~ event.location
    end

    test "Displays the tickets available", %{conn: conn, ticket_type: ticket_type} do
      {:ok, _index_live, html} = live(conn, ~p"/home")

      assert html =~ "Available Tickets"
      assert html =~ ticket_type.name
      assert html =~ ticket_type.description
    end

    test "There is an add to cart button", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/home")

      assert html =~ "Cart"
    end

    test "Clicking the add to cart button on a ticket type that is not in the cart adds it to the cart",
         %{conn: conn, ticket_type: ticket_type} do
      {:ok, index_live, _html} = live(conn, ~p"/home")

      assert index_live
             |> element("#ticket_type-#{ticket_type.id}")
             |> render_click() =~ "Ticket added to cart"
    end

    test "Clicking the add to cart button on a ticket type that is not in the cart adds a quantity of 1 to the ticket type",
         %{conn: conn, ticket_type: ticket_type} do
      {:ok, index_live, _html} = live(conn, ~p"/home")

      assert index_live
             |> element("#ticket_type-#{ticket_type.id}")
             |> render_click()

      assert index_live
             |> element("#ticket_type-#{ticket_type.id}")
             |> render_click() =~ "Ticket already in cart , quantity increased by 1"
    end
  end
end
