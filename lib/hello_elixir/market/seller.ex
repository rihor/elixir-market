defmodule HelloElixir.Market.Seller do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sellers" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(seller, attrs) do
    seller
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
