defmodule ElixirConfAfrica.Cart do
  @moduledoc """
  The cart module
  """

  alias ElixirConfAfrica.TicketTypes

  @doc """
  Returns the ids of all the cart items in a list



  """
  def cart_list_ids(cart) do
    Enum.map(cart, fn cart_item -> cart_item.id end)
  end

  @doc """
  Increases the quantity of a cart item given the cart item and the quantity to increase by

  """

  def increase_cart_item_quantity(cart_item, quantity) do
    Map.put(cart_item, :quantity, quantity)
  end

  @doc """
  Adds a cart item to the cart given the cart and the cart item id to add

  """
  def add_to_cart(cart, cart_item_id) do
    cart_list_ids = cart_list_ids(cart)

    if Enum.member?(cart_list_ids, cart_item_id) == true do
      ticket_type = Enum.find(cart, fn item -> item.id == cart_item_id end)
      get_updated_cart("in-cart", ticket_type, cart)
    else
      ticket_type = TicketTypes.get_ticket_type!(cart_item_id)
      get_updated_cart("out-of-cart", ticket_type, cart)
    end
  end

  @doc """
  Returns the updated cart for when a cart item already in the cart or out of the cart  given the cart item and the cart

  """

  def get_updated_cart("in-cart", cart_item, cart) do
    cart_item_with_added_quantity =
      add_quantity_to_cart_item(cart, cart_item, cart_item.quantity + 1)

    cart
    |> Enum.filter(fn item -> item.id != cart_item.id end)
    |> Enum.concat([cart_item_with_added_quantity])
  end

  def get_updated_cart("out-of-cart", cart_item, cart) do
    cart_item_with_default_quantity_of_one =
      add_quantity_to_cart_item(cart, cart_item, 1)

    [cart_item_with_default_quantity_of_one | cart]
  end

  @doc """
  Returns the cart item with an increased quantity given the cart, the cart item and the quantity to increase by.
  It also checks if the cart item is already in the cart and increases the quantity if it is.

  """
  def add_quantity_to_cart_item(cart, cart_item, quantity) do
    case Enum.filter(cart, fn item -> item.id == cart_item.id end) do
      [] ->
        increase_cart_item_quantity(cart_item, quantity)

      _ ->
        cart
        |> Enum.filter(fn item -> item.id == cart_item.id end)
        |> Enum.map(fn item -> increase_cart_item_quantity(item, item.quantity + 1) end)
        |> List.first()
    end
  end
end
