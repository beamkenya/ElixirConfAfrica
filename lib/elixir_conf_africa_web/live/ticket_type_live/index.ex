defmodule ElixirConfAfricaWeb.TicketTypeLive.Index do
  use ElixirConfAfricaWeb, :live_view

  alias ElixirConfAfrica.TicketTypes
  alias ElixirConfAfrica.TicketTypes.TicketType

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :ticket_types, TicketTypes.list_ticket_types())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Ticket type")
    |> assign(:ticket_type, TicketTypes.get_ticket_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Ticket type")
    |> assign(:ticket_type, %TicketType{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Ticket types")
    |> assign(:ticket_type, nil)
  end

  @impl true
  def handle_info(
        {ElixirConfAfricaWeb.TicketTypeLive.FormComponent, {:saved, ticket_type}},
        socket
      ) do
    {:noreply, stream_insert(socket, :ticket_types, ticket_type)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    ticket_type = TicketTypes.get_ticket_type!(id)
    {:ok, _} = TicketTypes.delete_ticket_type(ticket_type)

    {:noreply, stream_delete(socket, :ticket_types, ticket_type)}
  end
end
