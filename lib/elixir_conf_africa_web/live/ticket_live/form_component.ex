defmodule ElixirConfAfricaWeb.TicketLive.FormComponent do
  use ElixirConfAfricaWeb, :live_component

  alias ElixirConfAfrica.Tickets
  alias ElixirConfAfrica.Paystack

  @impl true
  def update(%{ticket: ticket} = assigns, socket) do
    changeset = Tickets.change_ticket(ticket)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"ticket" => ticket_params}, socket) do
    changeset =
      socket.assigns.ticket
      |> Tickets.change_ticket(ticket_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"ticket" => ticket_params}, socket) do
    save_ticket(socket, socket.assigns.action, ticket_params)
  end

  defp save_ticket(socket, :edit, ticket_params) do
    case Tickets.update_ticket(socket.assigns.ticket, ticket_params) do
      {:ok, _ticket} ->
        {:noreply,
         socket
         |> put_flash(:info, "Ticket updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_ticket(socket, :new, ticket_params) do
    case Tickets.create_ticket(ticket_params) do
      {:ok, _ticket} ->
        {:noreply,
         socket
         |> put_flash(:info, "Ticket created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_ticket(socket, :ticket, ticket_params) do
    cost = socket.assigns.ticket_type.price * String.to_integer(ticket_params["quantity"])

    paystack_initailization =
      Paystack.initialize(ticket_params["email"], cost)

    new_ticket_params =
      ticket_params
      |> Map.put("ticket_type_id", socket.assigns.ticket_type.id)
      |> Map.put("ticketid", paystack_initailization["reference"])
      |> Map.put("cost", cost)

    case Tickets.create_ticket(new_ticket_params) do
      {:ok, _ticket} ->
        {:noreply,
         socket
         |> redirect(external: paystack_initailization["authorization_url"])}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
