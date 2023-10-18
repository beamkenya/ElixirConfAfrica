defmodule ElixirConfAfricaWeb.HomeLive.Index do
  use ElixirConfAfricaWeb, :live_view
  alias ElixirConfAfrica.Events
  alias ElixirConfAfrica.TicketTypes

  def mount(_params, _session, socket) do
    elixir_conf_africa_event = Events.get_elixir_conf_event_and_ticket_types()
    availabe_tickets = Events.get_all_available_tickets()
    cart = []
    total_price = get_total_price(cart)

    {:ok,
     socket
     |> assign(:available_tickets, availabe_tickets)
     |> assign(:cart, cart)
     |> assign(:total_price, total_price)
     |> assign(:page_state, "details")
     |> assign(:event, elixir_conf_africa_event)}
  end

  def handle_event("add_to_cart", %{"id" => id}, socket) do
    ticket_type =
      TicketTypes.get_ticket_type!(String.to_integer(id))
      |> Map.put(:quantity, 1)

    if Enum.member?(socket.assigns.cart, ticket_type) do
      {:noreply,
       socket
       |> put_flash(:error, "Ticket already in cart")}
    else
      new_cart_items = [ticket_type | socket.assigns.cart]
      total_price = get_total_price(new_cart_items)

      {:noreply,
       socket
       |> put_flash(:info, "Ticket added to cart")
       |> assign(:cart, new_cart_items)
       |> assign(:total_price, total_price)}
    end
  end

  def handle_event("change_page_state", %{"page_state" => page_state}, socket) do
    {:noreply,
     socket
     |> assign(:page_state, page_state)}
  end

  defp get_total_price(cart) do
    Enum.reduce(cart, 0, fn ticket_type, acc ->
      acc + Decimal.to_integer(ticket_type.price) * ticket_type.quantity
    end)
  end
end
