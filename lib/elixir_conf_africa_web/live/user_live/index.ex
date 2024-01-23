defmodule ElixirConfAfricaWeb.UserLive.Index do
  use ElixirConfAfricaWeb, :admin_live_view

  alias ElixirConfAfrica.Accounts

  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    users =
      Accounts.list_users_apart_from_current_user(current_user)

    {:ok,
     socket
     |> assign(:users, users)
     |> assign(:current_user, current_user)}
  end

  def handle_event("change_role", %{"role" => role, "email" => email}, socket) do
    user = Accounts.get_user_by_email(email)
    {:ok, _user} = Accounts.update_user_role(user, role)

    {:noreply,
     socket
     |> put_flash(:info, "User role changed successfully")
     |> assign(:users, Accounts.list_users_apart_from_current_user(socket.assigns.current_user))}
  end
end
