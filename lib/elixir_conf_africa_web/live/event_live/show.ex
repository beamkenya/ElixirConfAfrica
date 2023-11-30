defmodule ElixirConfAfricaWeb.EventLive.Show do
  @moduledoc false
  use ElixirConfAfricaWeb, :live_view

  alias ElixirConfAfrica.Events
  alias ElixirConfAfrica.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    event =
      id
      |> Events.get_event!()
      |> Repo.preload(:ticket_types)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:event, event)}
  end

  defp page_title(:show), do: "Show Event"
  defp page_title(:edit), do: "Edit Event"
end
