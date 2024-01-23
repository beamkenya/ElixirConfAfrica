defmodule ElixirConfAfricaWeb.UserLiveTest do
  use ElixirConfAfricaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias ElixirConfAfrica.Factory

  describe "System Users Page" do
    setup %{conn: conn} do
      # sign up first
      conn =
        post(conn, ~p"/users/register",
          method: :create,
          user: %{email: "admin@gmail.com", password: "123456", role: "admin"}
        )

      user_1 =
        Factory.insert(:user, email: "test1@gmail.com", hashed_password: "123456", role: "user")

      scanner_1 =
        Factory.insert(:user,
          email: "test2@gmail.com",
          hashed_password: "123456",
          role: "scanner"
        )

      admin_1 =
        Factory.insert(:user, email: "admin2@gmail.com", hashed_password: "123456", role: "admin")

      [
        conn: conn,
        user_1: user_1,
        scanner_1: scanner_1,
        admin_1: admin_1
      ]
    end

    test "on /users you see all users apart from the current user", %{
      conn: conn,
      user_1: user_1,
      scanner_1: scanner_1,
      admin_1: admin_1
    } do
      {:ok, _index_live, html} = live(conn, ~p"/users")

      assert html =~ "Listing Users"
      assert html =~ user_1.email
      assert html =~ scanner_1.email
      assert html =~ admin_1.email
    end

    test "for admin users , you can only see a button to make the user a normal user or scanner and not to make them an admin",
         %{
           conn: conn,
           admin_1: admin_1
         } do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert has_element?(index_live, "#make-user-#{admin_1.id}")
      assert has_element?(index_live, "#make-scanner-#{admin_1.id}")
      refute has_element?(index_live, "#make-admin-#{admin_1.id}")
    end

    test "you can change a users  role when you click a button", %{
      conn: conn,
      admin_1: admin_1
    } do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert has_element?(index_live, "#role-#{admin_1.id}", admin_1.role)

      html =
        index_live
        |> element("#make-user-#{admin_1.id}")
        |> render_click()

      assert html =~ "User role changed successfully"

      assert has_element?(index_live, "#role-#{admin_1.id}", "user")
      refute has_element?(index_live, "#role-#{admin_1.id}", admin_1.role)
    end
  end
end
