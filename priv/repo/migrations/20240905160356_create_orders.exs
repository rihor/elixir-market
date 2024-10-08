defmodule HelloElixir.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create_query =
      "CREATE TYPE order_status AS ENUM ('shopping', 'waiting_payment', 'finished', 'expired')"

    drop_query = "DROP TYPE order_status"
    execute(create_query, drop_query)

    create table(:orders) do
      add :customer_id, references(:customers, on_delete: :delete_all)
      add :status, :order_status, null: false, default: "shopping"
      # in case of order being created without the user having logged in
      add :logged_out_session, :string

      timestamps(type: :utc_datetime)
    end
  end
end
