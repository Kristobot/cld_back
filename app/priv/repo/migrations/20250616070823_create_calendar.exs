defmodule App.Repo.Migrations.CreateCalendar do
  use Ecto.Migration

  def up do
    create table(:calendars) do
      add :color, :string
      add :weekly_availabilities, :text
      add :dentist_id, references(:users), null: false

      timestamps()
    end
  end

  def down do
    drop table(:calendars)
  end
end
