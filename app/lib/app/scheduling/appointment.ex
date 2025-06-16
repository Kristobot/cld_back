defmodule App.Scheduling.Appointment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "appointments" do
    field :status, :integer, default: 0
    field :reason, :string
    field :notes, :string
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    belongs_to :dentist, App.Accounts.User, foreign_key: :dentist_id
    belongs_to :patient, App.Patients.Patient
    belongs_to :scheduler, App.Accounts.User, foreign_key: :scheduler_id


    timestamps()
  end
end
