defmodule App.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :email, :string
      add :password, :string
      add :role, :integer
      timestamps()
    end
  end

  def down do
    drop table(:users)
  end
end
