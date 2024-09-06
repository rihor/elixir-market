defmodule HelloElixir.Market.Order do
  alias HelloElixir.Market.Customer
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :status, Ecto.Enum, values: [:shopping, :waiting_payment, :finished, :expired]
    belongs_to :customer, Customer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [])
    |> validate_required([])
  end
end
