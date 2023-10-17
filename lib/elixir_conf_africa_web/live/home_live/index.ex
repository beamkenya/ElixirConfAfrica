defmodule ElixirConfAfricaWeb.HomeLive.Index do
  use ElixirConfAfricaWeb, :live_view
  alias ElixirConfAfrica.Events

  def mount(_params, _session, socket) do
    elixir_conf_africa_event = Events.get_elixir_conf_event_and_ticket_types()
    availabe_tickets = Events.get_all_available_tickets()

    {:ok,
     socket
     |> assign(:available_tickets, availabe_tickets)
     |> assign(:cart, [])
     |> assign(:event, elixir_conf_africa_event)}
  end

  def handle_event("add_to_cart", %{"id" => id}, socket) do
    if Enum.member?(socket.assigns.cart, String.to_integer(id)) do
      {:noreply,
       socket
       |> put_flash(:error, "Ticket already in cart")}
    else
      new_cart_items = socket.assigns.cart ++ [String.to_integer(id)]

      {:noreply,
       socket
       |> assign(:cart, new_cart_items)}
    end
  end
end
