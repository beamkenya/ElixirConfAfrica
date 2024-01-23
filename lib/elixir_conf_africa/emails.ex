defmodule ElixirConfAfrica.Emails do
  @moduledoc """
  The Emails module is responsible for all the interactions with the Sendgrid API
  """

  @doc """
  Delivers a ticket by email
  """

  def deliver_ticket_by_email(email, url) do
    header = [
      {"Authorization",
       "Bearer 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"},
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]

    body = %{
      "from" => %{
        "email" => "Mche <mcheafrica@gmail.com>"
      },
      "personalizations" => [
        %{
          "to" => [
            %{"email" => email}
          ],
          "dynamic_template_data" => %{
            "url" => url
          }
        }
      ],
      "template_id" => "d-0b163cbd94794e5ca1757b26b38f76dc"
    }

    HTTPoison.post(
      "https://api.sendgrid.com/v3/mail/send",
      Jason.encode!(body),
      header
    )
  end
end
