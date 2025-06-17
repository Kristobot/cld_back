defmodule App.Scheduling.Calendar do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calendars" do
    field :color, :string, default: "#3b82f6"
    field :time_zone, :string, default: "America/New_York"
    field :weekly_availabilities, App.Types.Json, struct: App.Scheduling.WeeklyAvailability
    belongs_to :dentist, App.Accounts.User, foreign_key: :dentist_id

    timestamps()
  end

  def changeset(calendar, attrs) do
    calendar
    |> cast(attrs, [:color, :weekly_availabilities, :dentist_id, :time_zone])
    |> validate_required([:color, :weekly_availabilities, :dentist_id, :time_zone])
    |> foreign_key_constraint(:dentist_id)
    |> unique_day_of_week()
  end

  def update_changeset(calendar, attrs) do
    calendar
    |> cast(attrs, [:weekly_availabilities])
    |> unique_day_of_week()
  end

  def unique_day_of_week(changeset) do
    case get_field(changeset, :weekly_availabilities) do
      nil -> changeset
      weekly_availability ->
        case Enum.uniq_by(weekly_availability, & &1.day_of_week) do
          ^weekly_availability -> changeset
          _ -> add_error(changeset, :weekly_availabilities, "Day of week must be unique")
        end
    end
  end
end
