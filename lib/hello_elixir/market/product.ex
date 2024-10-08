defmodule HelloElixir.Market.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
