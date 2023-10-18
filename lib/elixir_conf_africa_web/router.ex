defmodule ElixirConfAfricaWeb.Router do
  use ElixirConfAfricaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ElixirConfAfricaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirConfAfricaWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/home", HomeLive.Index, :index

    live "/events", EventLive.Index, :index
    live "/events/new", EventLive.Index, :new
    live "/events/:id/edit", EventLive.Index, :edit

    live "/events/:id", EventLive.Show, :show
    live "/events/:id/show/edit", EventLive.Show, :edit

    live "/ticket_types", TicketTypeLive.Index, :index
    live "/ticket_types/new", TicketTypeLive.Index, :new
    live "/ticket_types/:id/edit", TicketTypeLive.Index, :edit

    live "/ticket_types/:id", TicketTypeLive.Show, :show
    live "/ticket_types/:id/show/edit", TicketTypeLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirConfAfricaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elixir_conf_africa, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ElixirConfAfricaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
