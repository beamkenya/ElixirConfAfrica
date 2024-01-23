defmodule ElixirConfAfrica.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: ElixirConfAfrica.Repo
  alias ElixirConfAfrica.Accounts.User
  alias ElixirConfAfrica.Tickets.Ticket
  alias ElixirConfAfrica.TicketTypes.TicketType

  def ticket_type_factory do
    %TicketType{
      name: "some name",
      description: "some description",
      price: 42,
      number: 49
    }
  end

  def ticket_factory do
    %Ticket{
      ticketid: Integer.to_string(System.unique_integer([:positive])),
      email: sequence(:email, fn n -> "email-#{n}@example" end),
      cost: 400,
      quantity: 1
    }
  end

  def user_factory do
    %User{
      email: "some email",
      password: "some password"
    }
  end
end
