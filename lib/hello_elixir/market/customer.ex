defmodule HelloElixir.Market.Customer do
  alias HelloElixir.Market.Order
  alias HelloElixir.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :address, :string
    has_one :user, User
    has_many :orders, Order

    timestamps(type: :utc_datetime)
  end

  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:address])
    |> validate_required([])
  end
end
