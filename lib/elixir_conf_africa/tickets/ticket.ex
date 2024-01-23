defmodule ElixirConfAfrica.Tickets.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :name, :string
    field :email, :string
    field :ticketid, :string
    field :quantity, :integer
    field :cost, :integer
    belongs_to :ticket_type, ElixirConfAfrica.TicketTypes.TicketType
    field :is_paid, :boolean, default: false
    field :is_refunded, :boolean, default: false
    field :phone_number, :string
    field :is_scanned, :boolean, default: false
    field :email_sent, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [
      :name,
      :email,
      :ticketid,
      :quantity,
      :ticket_type_id,
      :cost,
      :is_paid,
      :is_scanned,
      :is_refunded,
      :phone_number,
      :email_sent
    ])
    |> validate_required([
      :name,
      :email,
      :ticketid,
      :quantity,
      :ticket_type_id,
      :cost,
      :is_paid,
      :is_refunded,
      :is_scanned,
      :email_sent
    ])
    |> unique_constraint(:ticketid)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
  end
end
