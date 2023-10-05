defmodule ElixirConfAfricaWeb.EventsLive do
  alias ElixirConfAfrica.Tickets
  use ElixirConfAfricaWeb, :live_view

  alias ElixirConfAfrica.Events
  alias ElixirConfAfrica.Events.Event
  alias ElixirConfAfrica.Ticket
  alias ElixirConfAfrica.Tickets.Ticket

  def mount(_params, _session, socket) do
    events = Events.list_events()

    event_changeset = Events.change_event(%Event{})
    ticket_changeset = Tickets.change_ticket(%Ticket{})

    {:ok,
     assign(socket,
       events: events,
       event_form: to_form(event_changeset),
       ticket_form: to_form(ticket_changeset),
       show_ticket_form: false
     )}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    event = Events.get_event!(id)
    {:noreply, assign(socket, selected_event: event)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, selected_event: hd(socket.assigns.events))}
  end

  def render(assigns) do
    ~H"""
    <h1>Events</h1>
    <div class="flex gap-10">
      <%!-- sidebar --%>
      <div>
        <div class="flex flex-col">
          <.link patch={~p"/events/new"}>
            Add New Event
          </.link>
          <.link :for={event <- @events} patch={~p"/events?#{[id: event]}"}>
            <span><%= event.event_type %></span>
            <%= event.name %>
          </.link>
        </div>
      </div>
      <%!-- main section --%>
      <div>
        <.event_form :if={@live_action == :new} form={@event_form} />
        <div :if={@live_action != :new}>
          <h1><%= @selected_event.name %></h1>
          <.button phx-click="toggle-ticket-form">
            Add ticket type
          </.button>
          <.ticket_form :if={@show_ticket_form} form={@ticket_form} event_id={@selected_event.id} />
          <ul>
            <li>Location: <%= @selected_event.location %></li>
            <li>Start: <%= @selected_event.start_date %></li>
            <li>End: <%= @selected_event.end_date %></li>
          </ul>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("save_event", %{"event" => event_params}, socket) do
    case Events.create_event(event_params) do
      {:ok, event} ->
        socket =
          update(
            socket,
            :events,
            fn events -> [event | events] end
          )

        changeset = Events.change_event(%Event{})

        {:noreply, assign(socket, :event_form, to_form(changeset))}

      {:error, changeset} ->
        {:noreply, assign(socket, :event_form, to_form(changeset))}
    end
  end

  def handle_event("save_ticket", %{"ticket" => ticket_params}, socket) do
    case Tickets.create_ticket(ticket_params) do
      {:ok, _ticket} ->
        changeset = Tickets.change_ticket(%Ticket{})
        socket = assign(socket, :ticket_form, to_form(changeset))

        {:noreply, update(socket, :show_ticket_form, &(!&1))}

      {:error, changeset} ->
        {:noreply, assign(socket, :ticket_form, to_form(changeset))}
    end
  end

  def handle_event("toggle-ticket-form", _params, socket) do
    {:noreply, update(socket, :show_ticket_form, &(!&1))}
  end

  def event_form(assigns) do
    ~H"""
    <div>
      <h2>Add New Event</h2>
      <.form for={@form} phx-submit="save_event">
        <.input field={@form[:name]} placeholder="Event name" />
        <.input field={@form[:event_type]} placeholder="Event type" />
        <.input field={@form[:location]} placeholder="Event location" />
        <.input field={@form[:start_date]} type="datetime-local" placeholder="Start date" />
        <.input field={@form[:end_date]} type="datetime-local" placeholder="End date" />
        <.button phx-disable-with="Saving...">
          Save Event
        </.button>
      </.form>
    </div>
    """
  end

  def ticket_form(assigns) do
    ~H"""
    <div>
      <h2>Add New Ticket</h2>
      <.form for={@form} phx-submit="save_ticket">
        <.input field={@form[:event_id]} type="hidden" value={@event_id} />
        <.input field={@form[:type]} placeholder="Ticket type" />
        <.input field={@form[:description]} placeholder="Ticket description" />
        <.input field={@form[:price]} type="number" placeholder="Ticket price" />
        <.input field={@form[:ticket_number]} type="number" placeholder="Ticket number" />
        <.button phx-disable-with="Saving...">
          Save Ticket
        </.button>
      </.form>
    </div>
    """
  end
end
