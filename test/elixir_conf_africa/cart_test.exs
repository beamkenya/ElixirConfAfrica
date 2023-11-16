defmodule ElixirConfAfrica.CartTest do
  use ElixirConfAfrica.DataCase
  alias ElixirConfAfrica.Cart

  describe "Cart Functionaity" do
    import ElixirConfAfrica.Factory

    setup do
      event = insert!(:elixir_conf_event)
      ticket_type = insert!(:elixir_conf_ticket_type, event_id: event.id)

      [ticket_type: ticket_type]
    end

    test "cart_list_ids/1  returns all ids from the carts in a list" do
      assert Cart.cart_list_ids([%{id: 1}, %{id: 2}]) == [1, 2]
    end

    test "increase_cart_item_quantity/2 increases the quantity of a cart item" do
      assert Cart.increase_cart_item_quantity(%{quantity: 1}, 2) == %{quantity: 2}
    end

    test "add quantity to cart_item/3 returns the cart item with an increased quantity " do
      assert Cart.add_quantity_to_cart_item([%{id: 1, quantity: 1}], %{id: 1, quantity: 1}, 2) ==
               %{id: 1, quantity: 2}

      assert Cart.add_quantity_to_cart_item([%{id: 1, quantity: 1}], %{id: 2}, 1) ==
               %{id: 2, quantity: 1}
    end

    test "get_updated_cart/3 returns the updated cart" do
      assert Cart.get_updated_cart("in-cart", %{id: 1, quantity: 1}, [%{id: 1, quantity: 1}]) ==
               [%{id: 1, quantity: 2}]

      assert Cart.get_updated_cart("out-of-cart", %{id: 2}, [%{id: 1, quantity: 1}]) ==
               [%{id: 2, quantity: 1}, %{id: 1, quantity: 1}]
    end

    test "add_to_cart/2 adds an item to the cart", %{ticket_type: ticket_type} do
      assert Cart.add_to_cart([%{id: 1, quantity: 1}, %{id: 2, quantity: 1}], 1) ==
               [%{id: 2, quantity: 1}, %{id: 1, quantity: 2}]

      assert Cart.add_to_cart([%{id: 1, quantity: 1}, %{id: 2, quantity: 1}], ticket_type.id) ==
               [
                 ticket_type |> Map.put(:quantity, 1),
                 %{id: 1, quantity: 1},
                 %{id: 2, quantity: 1}
               ]
    end
  end
end
