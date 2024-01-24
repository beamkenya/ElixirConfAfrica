defmodule ElixirConfAfrica.Transaction do
  defstruct [:reference, :amount, :status, :currency, :paid_at, :email, :bank]
end
