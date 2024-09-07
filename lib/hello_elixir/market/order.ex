defmodule HelloElixir.Market.Order do
  alias HelloElixir.Market.Customer
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :status, Ecto.Enum, values: [:shopping, :waiting_payment, :finished, :expired]
    # in case of order being created without the user having logged in
    field :logged_out_session, :string
    belongs_to :customer, Customer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:logged_out_session])
    |> validate_required([])
  end
end
