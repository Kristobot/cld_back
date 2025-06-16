defmodule App.Scheduling.Calendar do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calendars" do
    field :color, :string, default: "#3b82f6"
    field :weekly_availability, App.Types.Json, struct: App.Scheduling.WeeklyAvailability
    belongs_to :dentist, App.Accounts.User, foreign_key: :dentist_id

    timestamps()
  end

  def changeset(calendar, attrs) do
    calendar
    |> cast(attrs, [:color, :weekly_availability, :dentist_id])
    |> validate_required([:color, :weekly_availability, :dentist_id])
    |> foreign_key_constraint(:dentist_id)
    |> unique_day_of_week()
  end

  def update_changeset(calendar, attrs) do
    calendar
    |> cast(attrs, [:weekly_availability])
    |> unique_day_of_week()
  end

  def unique_day_of_week(changeset) do
    case get_field(changeset, :weekly_availability) do
      nil -> changeset
      weekly_availability ->
        case Enum.uniq_by(weekly_availability, & &1.day_of_week) do
          ^weekly_availability -> changeset
          _ -> add_error(changeset, :weekly_availability, "Day of week must be unique")
        end
    end
  end
end
