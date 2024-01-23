defmodule ElixirConfAfricaWeb.TransactionLiveTest do
  use ElixirConfAfricaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias ElixirConfAfrica.Paystack

  describe "This page lists all transactions made" do
    setup %{conn: conn} do
      # sign up first
      conn =
        post(conn, ~p"/users/register",
          method: :create,
          user: %{email: "admin@gmail.com", password: "123456", role: "admin"}
        )

      %{"reference" => reference1} =
        Paystack.initialize("michaelmunavu83@gmail.com", 400)

      %{"reference" => reference2} =
        Paystack.initialize("michaelmunavu83@gmail.com", 400)

      [
        reference1: reference1,
        reference2: reference2,
        conn: conn
      ]
    end

    test "on /transactions , you see all the transactions made", %{
      conn: conn,
      reference1: reference1,
      reference2: reference2
    } do
      {:ok, _index_live, html} = live(conn, ~p"/transactions")

      assert html =~ "Listing Transactions"
      assert html =~ reference1
      assert html =~ reference2
    end
  end
end
