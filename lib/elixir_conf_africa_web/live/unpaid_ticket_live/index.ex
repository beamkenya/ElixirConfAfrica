defmodule ElixirConfAfricaWeb.UnPaidTicketLive.Index do
  use ElixirConfAfricaWeb, :admin_live_view

  alias ElixirConfAfrica.Emails
  alias ElixirConfAfrica.Tickets

  alias ElixirConfAfrica.Paystack
  @impl true
  def mount(_params, _session, socket) do
    unpaid_tickets = Tickets.list_unpaid_tickets()

    {:ok,
     socket
     |> assign(:page_number, unpaid_tickets.page_number)
     |> assign(:page_size, unpaid_tickets.page_size)
     |> assign(:total_entries, unpaid_tickets.total_entries)
     |> assign(:total_pages, unpaid_tickets.total_pages)
     |> assign(:ticket_collection, list_unpaid_tickets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("update_and_send_ticket", %{"ticketid" => ticketid}, socket) do
    ticket = Tickets.get_ticket_by_ticketid!(ticketid)
    Emails.deliver_ticket_by_email(ticket.email, "localhost:4900/tickets/#{ticket.ticketid}")
    {:ok, _ticket} = Tickets.update_ticket(ticket, %{is_paid: true, email_sent: true})

    {:noreply,
     socket
     |> assign(:ticket_collection, list_unpaid_tickets())
     |> put_flash(:info, "Ticket sent successfully")}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing UnPaid Tickets")
  end

  defp list_unpaid_tickets do
    Tickets.list_unpaid_tickets().entries
    |> Enum.map(fn ticket ->
      ticket
      |> Map.put(:payment_status, check_payment_status(ticket.ticketid))
    end)
    |> IO.inspect()
  end

  defp check_payment_status(ticketid) do
    case Paystack.test_verification(ticketid) do
      %{"status" => "success"} -> "incorrect"
      %{"status" => "failed"} -> "correct"
      _ -> "correct"
    end
  end
end
