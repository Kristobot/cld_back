defmodule App.Scheduling.WeeklyAvailability do
  use Ecto.Schema

  embedded_schema do
    field :day_of_week, :integer
    field :start_time, :time
    field :end_time, :time
    field :closed, :boolean
  end
end
