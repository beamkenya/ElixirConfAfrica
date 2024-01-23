defmodule ElixirConfAfricaWeb.UnPaidTicketLive.Index do
  use ElixirConfAfricaWeb, :admin_live_view

  alias ElixirConfAfrica.Emails
  alias ElixirConfAfrica.Tickets

  alias ElixirConfAfrica.Paystack
  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :ticket_collection, list_unpaid_tickets())}
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
    Tickets.list_unpaid_tickets()
    |> Enum.map(fn ticket ->
      %{
        id: ticket.id,
        name: ticket.name,
        email: ticket.email,
        quantity: ticket.quantity,
        phone_number: ticket.phone_number,
        cost: ticket.cost,
        ticketid: ticket.ticketid,
        ticket_type_id: ticket.ticket_type_id,
        is_paid: ticket.is_paid,
        is_refunded: ticket.is_refunded,
        ticket_type: ticket.ticket_type,
        payment_status: check_payment_status(ticket.ticketid)
      }
    end)
  end

  defp check_payment_status(ticketid) do
    case Paystack.test_verification(ticketid) do
      %{"status" => "success"} -> "incorrect"
      %{"status" => "failed"} -> "correct"
      _ -> "correct"
    end
  end
end
