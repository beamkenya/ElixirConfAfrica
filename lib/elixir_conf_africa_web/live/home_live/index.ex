defmodule ElixirConfAfricaWeb.HomeLive.Index do
  use ElixirConfAfricaWeb, :live_view
  alias ElixirConfAfrica.Events

  alias ElixirConfAfrica.Cart

  def mount(_params, _session, socket) do
    event_name = "ElixirConf Africa #{get_upcoming_year()}"

    event =
      Events.get_event_with_ticket_types_by_event_name(event_name)

    available_tickets = Events.get_total_number_of_available_tickets(event_name)

    {:ok,
     socket
     |> assign(:event, event)
     |> assign(:cart, [])
     |> assign(available_tickets: available_tickets)}
  end

  defp get_upcoming_year do
    %{year: year} = DateTime.utc_now()
    year + 1
  end

  def handle_event("add_to_cart", %{"id" => id}, socket) do
    cart_item_ids = Cart.cart_list_ids(socket.assigns.cart)

    if Enum.member?(cart_item_ids, String.to_integer(id)) do
      updated_cart = Cart.add_to_cart(socket.assigns.cart, String.to_integer(id))

      {:noreply,
       socket
       |> assign(:cart, updated_cart)
       |> put_flash(:info, "Ticket already in cart , quantity increased by 1")}
    else
      updated_cart = Cart.add_to_cart(socket.assigns.cart, String.to_integer(id))

      {:noreply,
       socket
       |> put_flash(:info, "Ticket added to cart")
       |> assign(:cart, updated_cart)}
    end
  end
end
