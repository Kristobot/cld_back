defmodule App.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def up do
    create table(:people) do
      add :first_name, :string
      add :last_name, :string
      add :phone_number, :string
      add :date_of_birth, :date
      add :address, :string
      add :specialty, :integer
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end

  def down do
    drop table(:people)
  end
end
