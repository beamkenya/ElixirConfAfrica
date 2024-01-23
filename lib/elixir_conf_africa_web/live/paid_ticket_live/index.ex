defmodule ElixirConfAfricaWeb.PaidTicketLive.Index do
  use ElixirConfAfricaWeb, :admin_live_view

  alias ElixirConfAfrica.Tickets
  alias ElixirConfAfrica.Emails

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :ticket_collection, list_paid_tickets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Paid Tickets")
  end

  @impl true

  def handle_event("send_email", %{"ticketid" => ticketid}, socket) do
    ticket = Tickets.get_ticket_by_ticketid!(ticketid)
    Emails.deliver_ticket_by_email(ticket.email, "localhost:4900/tickets/#{ticket.ticketid}")

    {:noreply,
     socket
     |> put_flash(:info, "Ticket sent successfully")}
  end

  defp list_paid_tickets do
    Tickets.list_paid_tickets()
  end
end
