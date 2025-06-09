defmodule App.Scheduling.Appointment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "appointments" do
    field :date, :utc_datetime
    field :status, :integer, default: 0
    field :reason, :string
    field :notes, :string

    belongs_to :dentist, App.Accounts.Person

    timestamps()
  end
end
