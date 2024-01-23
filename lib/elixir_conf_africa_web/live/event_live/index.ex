defmodule ElixirConfAfricaWeb.EventLive.Index do
  use ElixirConfAfricaWeb, :live_view

  alias ElixirConfAfrica.Tickets.Ticket
  alias ElixirConfAfrica.TicketTypes
  @impl true
  def mount(_params, _session, socket) do
    ticket_types = TicketTypes.list_ticket_types_with_remaining_tickets()
    {:ok, assign(socket, :ticket_types, ticket_types)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "ElixirConf Africa 2024")
  end

  defp apply_action(socket, :ticket, params) do
    ticket_type = TicketTypes.get_ticket_type!(params["ticket_type_id"])

    socket
    |> assign(:page_title, "#{ticket_type.name} Ticket")
    |> assign(:ticket_type, ticket_type)
    |> assign(:ticket, %Ticket{})
  end
end
