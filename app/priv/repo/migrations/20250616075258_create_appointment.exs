defmodule App.Repo.Migrations.CreateAppointment do
  use Ecto.Migration

  def up do
    create table(:appointments) do
      add :status, :integer
      add :reason, :text
      add :notes, :text
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :dentist_id, references(:users), null: false
      add :patient_id, references(:patients), null: false
      add :scheduler_id, references(:users), null: false

      timestamps()
    end
  end

  def down do
    drop table(:appointments)
  end
end
