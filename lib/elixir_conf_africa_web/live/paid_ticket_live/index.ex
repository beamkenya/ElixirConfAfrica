defmodule ElixirConfAfricaWeb.PaidTicketLive.Index do
  use ElixirConfAfricaWeb, :admin_live_view

  alias ElixirConfAfrica.Emails
  alias ElixirConfAfrica.Tickets

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_number, list_paid_tickets().page_number)
     |> assign(:page_size, list_paid_tickets().page_size)
     |> assign(:total_entries, list_paid_tickets().total_entries)
     |> assign(:total_pages, list_paid_tickets().total_pages)
     |> assign(:ticket_collection, list_paid_tickets().entries)}
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

  defp list_paid_tickets() do
    Tickets.list_paid_tickets()
    |> IO.inspect()
  end
end
