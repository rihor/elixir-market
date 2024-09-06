defmodule HelloElixir.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    create index(:products, [:name])
  end
end
