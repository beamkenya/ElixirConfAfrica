defmodule ElixirConfAfricaWeb.TicketTypeLiveTest do
  use ElixirConfAfricaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias ElixirConfAfrica.Factory

  @update_attrs %{
    name: "some updated name",
    description: "some updated description",
    price: 43,
    number: 50
  }
  @invalid_attrs %{name: nil, description: nil, price: nil}

  describe "Index" do
    setup %{conn: conn} do
      # sign up first
      conn =
        post(conn, ~p"/users/register",
          method: :create,
          user: %{email: "admin@gmail.com", password: "123456", role: "admin"}
        )

      ticket_type = Factory.insert(:ticket_type)

      [
        ticket_type: ticket_type,
        conn: conn
      ]
    end

    test "lists all ticket_types", %{conn: conn, ticket_type: ticket_type} do
      {:ok, _index_live, html} = live(conn, ~p"/ticket_types")

      assert html =~ "Listing Ticket types"
      assert html =~ ticket_type.name
    end

    test "saves new ticket_type", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/ticket_types")

      assert index_live |> element("a", "New Ticket Type") |> render_click() =~
               "New Ticket Type"

      assert_patch(index_live, ~p"/ticket_types/new")

      assert index_live
             |> form("#ticket_type-form", ticket_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#ticket_type-form",
          ticket_type: %{
            name: "early bird",
            description: "some description",
            price: 42,
            number: 49
          }
        )
        |> render_submit()
        |> follow_redirect(conn, ~p"/ticket_types")

      assert html =~ "Ticket type created successfully"
      assert html =~ "early bird"
    end

    test "updates ticket_type in listing", %{conn: conn, ticket_type: ticket_type} do
      {:ok, index_live, _html} = live(conn, ~p"/ticket_types")

      assert index_live |> element("#ticket_types-#{ticket_type.id}", "Edit") |> render_click() =~
               "Edit"

      assert_patch(index_live, ~p"/ticket_types/#{ticket_type}/edit")

      assert index_live
             |> form("#ticket_type-form", ticket_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#ticket_type-form", ticket_type: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/ticket_types")

      assert html =~ "Ticket type updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes ticket_type in listing", %{conn: conn, ticket_type: ticket_type} do
      {:ok, index_live, _html} = live(conn, ~p"/ticket_types")

      assert index_live |> element("#ticket_type-#{ticket_type.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#ticket_type-#{ticket_type.id}")
    end
  end
end
