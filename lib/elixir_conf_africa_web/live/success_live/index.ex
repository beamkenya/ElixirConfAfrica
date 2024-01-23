defmodule ElixirConfAfricaWeb.SuccessLive.Index do
  use ElixirConfAfricaWeb, :live_view

  alias ElixirConfAfrica.Tickets

  alias ElixirConfAfrica.Emails
  alias ElixirConfAfrica.Paystack

  def mount(params, _session, socket) do
    Paystack.test_verification(params["trxref"])

    case Paystack.test_verification(params["trxref"]) do
      # handle mpesa payments
      %{"status" => "success", "authorization" => %{"mobile_money_number" => phone_number}} ->
        ticket = Tickets.get_ticket_by_ticketid!(params["trxref"])

        case ticket.email_sent do
          true ->
            deliver_ticket_by_email(ticket.email, ticket.ticketid)

            {:ok, _ticket} =
              Tickets.update_ticket(ticket, %{is_paid: true, phone_number: phone_number})

          false ->
            {:ok, _ticket} =
              Tickets.update_ticket(ticket, %{
                is_paid: true,
                email_sent: true,
                phone_number: phone_number
              })
        end

        {:ok,
         socket
         |> assign(:success, true)
         |> assign(:ticket, ticket)}

      # handle card payments
      %{"status" => "success"} ->
        ticket = Tickets.get_ticket_by_ticketid!(params["trxref"])

        case ticket.email_sent do
          true ->
            deliver_ticket_by_email(ticket.email, ticket.ticketid)
            {:ok, _ticket} = Tickets.update_ticket(ticket, %{is_paid: true})

          false ->
            {:ok, _ticket} = Tickets.update_ticket(ticket, %{is_paid: true, email_sent: true})
        end

        {:ok,
         socket
         |> assign(:success, true)
         |> assign(:ticket, ticket)}

      %{"status" => "failed"} ->
        {:ok,
         socket
         |> assign(:success, false)}

      %{"status" => "abandoned"} ->
        {:ok,
         socket
         |> assign(:success, false)}
    end
  end

  def deliver_ticket_by_email(email, ticketid) do
    {:ok, _} =
      Emails.deliver_ticket_by_email(
        email,
        "http://5.189.162.107:3200/tickets/#{ticketid}"
      )
  end
end
