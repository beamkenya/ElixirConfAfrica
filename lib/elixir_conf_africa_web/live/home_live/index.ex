defmodule ElixirConfAfricaWeb.HomeLive.Index do
  use ElixirConfAfricaWeb, :live_view
  alias ElixirConfAfrica.Events
  alias ElixirConfAfrica.TicketTypes

  def mount(_params, _session, socket) do
    event_name = "ElixirConf Africa #{get_current_year()}"

    event =
      Events.get_event_with_ticket_types_by_event_name(event_name)

    available_ticket = Events.get_total_number_of_available_tickets(event_name)

    cart = []
    total_price = get_total_price(cart)

    {:ok,
     socket
     |> assign(:event, event)}
    |> assign(available_ticket: available_ticket)
  end

  defp get_current_year do
    %{year: year} = DateTime.utc_now()
    year
  end

  def handle_event("add_to_cart", %{"id" => id}, socket) do
    ticket_type =
      id
      |> String.to_integer()
      |> TicketTypes.get_ticket_type!()
      |> TicketTypes.add_quantity(1)

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
