defmodule AppWeb.Schema.WeeklyAvailability do
  use Absinthe.Schema.Notation

  object :weekly_availability do
    field :day_of_week, :integer
    field :start_time, :time
    field :end_time, :time
    field :closed, :boolean
  end

  input_object :weekly_availability_input do
    field :day_of_week, non_null(:integer)
    field :start_time, non_null(:time)
    field :end_time, non_null(:time)
    field :closed, non_null(:boolean)
  end
end
