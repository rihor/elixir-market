defmodule HelloElixir.Market.Seller do
  alias HelloElixir.Market.Product
  use Ecto.Schema
  import Ecto.Changeset

  schema "sellers" do
    field :name, :string
    has_many :products, Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(seller, attrs) do
    seller
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
