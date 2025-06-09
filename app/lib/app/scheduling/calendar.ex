defmodule App.Scheduling.Calendar do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calendars" do
    field :name, :string
    field :color, :string
    field :working_hours, :map

    belongs_to :dentist, App.Accounts.Person

    timestamps()
  end
end
