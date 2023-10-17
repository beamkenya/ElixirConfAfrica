defmodule ElixirConfAfricaWeb.HomeLive.CartComponent do
  use ElixirConfAfricaWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      tvgbhnjmk
      test
    </div>
    """
  end

  @impl true
  def update(params, socket) do
    IO.inspect(socket)

    {:ok, socket}
  end

  @impl true

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
