defmodule ElixirConfAfrica.PaystackTest do
  use ElixirConfAfrica.DataCase
  alias ElixirConfAfrica.Paystack

  describe "Paystack initialization , transaction verification and getting all transactions" do
    setup do
      [email: "michaelmunavu83@gmail.com", amount: 1000]
    end

    test "initialize/2 with a valid email and amount returns a map with a authorization url , transaction reference and access code",
         %{email: email, amount: amount} do
      assert %{
               "access_code" => _,
               "authorization_url" => _,
               "reference" => _
             } =
               Paystack.initialize(email, amount)
    end

    test "list_transactions/0 returns a list of transactions for that account and gets structured",
         %{email: email, amount: amount} do
      Paystack.initialize(email, amount)
      assert Paystack.list_transactions() != []
    end

    test "test_verification/1 returns a map with the transaction details", %{
      email: email,
      amount: amount
    } do
      %{
        "access_code" => _,
        "authorization_url" => _,
        "reference" => reference
      } =
        Paystack.initialize(email, amount)

      assert %{
               "amount" => _amount,
               "reference" => _reference
             } = Paystack.test_verification(reference)
    end
  end
end
