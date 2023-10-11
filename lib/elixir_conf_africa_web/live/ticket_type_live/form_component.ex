defmodule ElixirConfAfricaWeb.TicketTypeLive.FormComponent do
  use ElixirConfAfricaWeb, :live_component

  alias ElixirConfAfrica.TicketTypes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage ticket_type records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="ticket_type-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:event_id]} type="number" label="Event ID" />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:number]} type="number" label="Number" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:price]} type="number" label="Price" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Ticket type</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{ticket_type: ticket_type} = assigns, socket) do
    changeset = TicketTypes.change_ticket_type(ticket_type)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"ticket_type" => ticket_type_params}, socket) do
    changeset =
      socket.assigns.ticket_type
      |> TicketTypes.change_ticket_type(ticket_type_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"ticket_type" => ticket_type_params}, socket) do
    save_ticket_type(socket, socket.assigns.action, ticket_type_params)
  end

  defp save_ticket_type(socket, :edit, ticket_type_params) do
    case TicketTypes.update_ticket_type(socket.assigns.ticket_type, ticket_type_params) do
      {:ok, ticket_type} ->
        notify_parent({:saved, ticket_type})

        {:noreply,
         socket
         |> put_flash(:info, "Ticket type updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_ticket_type(socket, :new, ticket_type_params) do
    case TicketTypes.create_ticket_type(ticket_type_params) do
      {:ok, ticket_type} ->
        notify_parent({:saved, ticket_type})

        {:noreply,
         socket
         |> put_flash(:info, "Ticket type created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
