defmodule ElixirConfAfrica.Factory do
  @moduledoc false
  alias ElixirConfAfrica.Repo

  def build(:elixir_conf_event) do
    %ElixirConfAfrica.Events.Event{
      id: 1,
      name: "ElixirConf Africa 2024",
      description: "some description",
      location: "some location",
      event_type: "some event_type",
      start_date: ~N[2023-10-05 06:18:00],
      end_date: ~N[2023-10-05 06:18:00]
    }
  end

  def build(:elixir_conf_ticket_type) do
    %ElixirConfAfrica.TicketTypes.TicketType{
      name: "some name",
      description: "some description",
      price: 120.5,
      number: 357
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end

  # def build(factory_name, attributes) do
  #   factory_name |> build() |> struct!(attributes)
  # end

  # def insert!(factory_name, attributes \\ []) do
  #   factory_name |> build(attributes) |> Repo.insert!()
  # end
end
