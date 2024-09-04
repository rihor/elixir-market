defmodule HelloElixir.Market.Product do
  alias HelloElixir.Market.Seller
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    belongs_to :seller, Seller

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :seller_id])
    |> validate_required([:name, :seller_id])
  end
end
