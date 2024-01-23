defmodule ElixirConfAfricaWeb.TransactionLive.Index do
  use ElixirConfAfricaWeb, :admin_live_view

  alias ElixirConfAfrica.Paystack

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    transctions = Paystack.list_transactions()

    socket
    |> assign(:transactions, transctions)
    |> assign(:page_title, "Listing Transactions")
  end
end
