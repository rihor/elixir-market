defmodule HelloElixir.Market.OrderProduct do
  alias HelloElixir.Market.Order
  alias HelloElixir.Market.Product
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_products" do
    belongs_to :order, Order
    belongs_to :product, Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:order_id, :product_id])
    |> validate_required([:order_id, :product_id])
  end
end
