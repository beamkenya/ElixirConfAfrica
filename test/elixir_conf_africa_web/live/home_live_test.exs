defmodule ElixirConfAfricaWeb.HomeLiveTest do
  use ElixirConfAfricaWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Home" do
    test "There is a button to buy tickets", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Buy Tickets"
    end

    test "once clicked, the button takes you to the event page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      index_live |> element("a", "Buy Tickets") |> render_click() |> follow_redirect(conn)

      assert_redirect(index_live, ~p"/event")
    end
  end
end
