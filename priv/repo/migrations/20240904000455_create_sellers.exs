defmodule HelloElixir.Repo.Migrations.CreateSellers do
  use Ecto.Migration

  def change do
    create table(:sellers) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
