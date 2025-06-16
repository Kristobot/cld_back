defmodule AppWeb.Schema.Calendar do
  use Absinthe.Schema.Notation
  alias AppWeb.Middleware

  object :calendar do
    field :id, :id
    field :color, :string
    field :weekly_availability, list_of(:weekly_availability)
    field :dentist, :user
    field :inserted_at, :string
    field :updated_at, :string
  end

  object :weekly_availability do
    field :day_of_week, :integer
    field :start_time, :time
    field :end_time, :time
  end

  input_object :weekly_availability_input do
    field :day_of_week, non_null(:integer)
    field :start_time, non_null(:time)
    field :end_time, non_null(:time)
  end

  input_object :calendar_input do
    field :color, :string
    field :weekly_availability, list_of(:weekly_availability_input)
  end

  object :calendar_queries do
    field :get_calendar, :calendar do
      arg :id, non_null(:id)
      middleware Middleware.Authenticate
      resolve &App.Resolvers.Calendar.get_calendar/3
    end
  end

  object :calendar_mutations do
    field :create_calendar, :calendar do
      arg :input, non_null(:calendar_input)
      middleware Middleware.Authenticate
      resolve &App.Resolvers.Calendar.create_calendar/3
    end
  end
end
