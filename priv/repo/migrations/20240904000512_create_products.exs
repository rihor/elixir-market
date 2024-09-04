defmodule HelloElixir.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :seller_id, references(:sellers, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:products, [:seller_id])
  end
end
