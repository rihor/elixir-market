defmodule HelloElixir.Repo.Migrations.CreateOrderProduct do
  use Ecto.Migration

  def change do
    create table(:order_products) do
      add :order_id, references(:orders, on_delete: :delete_all)
      add :product_id, references(:products, on_delete: :delete_all)
      add :quantity, :integer, default: 1

      timestamps(type: :utc_datetime)
    end

    create index(:order_products, [:order_id, :product_id])
  end
end
