defmodule ElixirConfAfricaWeb.RefundedTicketLive.Index do
  use ElixirConfAfricaWeb, :admin_live_view

  alias ElixirConfAfrica.Tickets

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :ticket_collection, list_refunded_tickets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Refunded Tickets")
  end

  defp list_refunded_tickets do
    Tickets.list_refunded_tickets()
  end
end
