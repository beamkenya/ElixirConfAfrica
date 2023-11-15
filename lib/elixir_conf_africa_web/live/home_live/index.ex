defmodule ElixirConfAfricaWeb.HomeLive.Index do
  use ElixirConfAfricaWeb, :live_view
  alias ElixirConfAfrica.Events

  def mount(_params, _session, socket) do
    # these value are more static and we should find away of display this data to home page
    event_name = "ElixirConf Africa #{get_current_year()}"

    event =
      Events.get_event_with_ticket_types_by_event_name(event_name)

    available_ticket = Events.get_total_number_of_available_tickets(event_name)

    {:ok,
     socket
     |> assign(:event, event)}
    |> assign(available_ticket: available_ticket)
  end

  defp get_current_year do
    %{year: year} = DateTime.utc_now()
    year
  end
end
