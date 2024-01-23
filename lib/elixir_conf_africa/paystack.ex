defmodule ElixirConfAfrica.Paystack do
  @moduledoc """
  The Paystack module is responsible for all the interactions with the Paystack API
  """
  defp api_url(), do: "https://api.paystack.co/transaction/initialize"

  defp paystack_headers(),
    do: [
      {
        "Content-Type",
        "application/json"
      },
      {
        "Authorization",
        "Bearer #{api_key()}"
      }
    ]

  @doc """
  Initializes a transaction with Paystack and returns the transaction reference and a url to redirect to

  """
  def initialize(email, amount) do
    api_url = api_url()

    amount = amount * 100

    paystack_body =
      %{
        "email" => email,
        "amount" => amount,
        "callback_url" => "http://localhost:5800/success"
      }
      |> Jason.encode!()

    case HTTPoison.post(api_url, paystack_body, paystack_headers()) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Map.get("data")

      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  @doc """
  Verifies a transaction with Paystack and returns the transaction details

  """
  def test_verification(transaction_reference) do
    paystack_headers = paystack_headers()

    url = "https://api.paystack.co/transaction/verify/#{transaction_reference}"

    case HTTPoison.get(url, paystack_headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Map.get("data")

      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  @doc """
  Lists all transactions made

  """
  def list_transactions do
    get_transactions()
    |> Enum.map(fn transaction ->
      %{
        "reference" => transaction["reference"],
        "amount" => transaction["amount"],
        "status" => transaction["status"],
        "currency" => transaction["currency"],
        "paid_at" => transaction["paid_at"],
        "email" => transaction["customer"]["email"],
        "bank" => transaction["authorization"]["bank"]
      }
    end)
  end

  defp get_transactions do
    url = "https://api.paystack.co/transaction"

    case HTTPoison.get(url, paystack_headers()) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Map.get("data")

      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  defp api_key do
    if Mix.env() == :test do
      "sk_test_46828225be64577ea7523018d51bb119d00d4e40"
    else
      "sk_test_46828225be64577ea7523018d51bb119d00d4e40"
    end
  end
end
