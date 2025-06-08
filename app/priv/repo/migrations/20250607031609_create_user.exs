defmodule App.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :email, :string
      add :password, :string
      add :role, :integer
      timestamps()
    end

    create unique_index(:users, [:email])
  end

  def down do
    drop table(:users)
  end
end
