defmodule ElixirConfAfricaWeb.HomeLive.Index do
  use ElixirConfAfricaWeb, :live_view
  alias ElixirConfAfrica.Events

  def mount(_params, _session, socket) do
    elixir_conf_africa_event = Events.get_elixir_conf_event_and_ticket_types()
    availabe_tickets = Events.get_all_available_tickets()

    {:ok,
     socket
     |> assign(:available_tickets, availabe_tickets)
     |> assign(:event, elixir_conf_africa_event)}
  end
end
