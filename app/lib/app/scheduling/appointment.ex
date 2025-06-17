defmodule App.Scheduling.Appointment do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Accounts

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

  def changeset(appointment, attrs) do
    appointment
    |> cast(attrs, [:status, :reason, :notes, :start_time, :end_time, :dentist_id, :patient_id, :scheduler_id])
    |> validate_required([:status, :reason, :notes, :start_time, :end_time, :dentist_id, :patient_id, :scheduler_id])
    |> foreign_key_constraint(:dentist_id)
    |> foreign_key_constraint(:patient_id)
    |> foreign_key_constraint(:scheduler_id)
    |> is_dentist()
  end

  defp is_dentist(changeset) do
    case get_field(changeset, :dentist_id) do
      nil -> add_error(changeset, :dentist_id, "Dentist is required")
      dentist_id ->
        case Accounts.is_dentist?(dentist_id) do
          {:error, :not_found} -> add_error(changeset, :dentist_id, "Dentist not found")
          false -> add_error(changeset, :dentist_id, "User is not a dentist")
          true -> changeset
        end
    end
  end

end
