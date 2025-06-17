defmodule AppWeb.Schema.Calendar do
  use Absinthe.Schema.Notation
  alias AppWeb.Middleware

  object :calendar do
    field :id, :id
    field :color, :string
    field :time_zone, :string
    field :weekly_availabilities, list_of(:weekly_availability)
    field :dentist, :user
    field :inserted_at, :string
    field :updated_at, :string
  end

  input_object :calendar_input do
    field :color, :string
    field :time_zone, non_null(:string)
    field :weekly_availabilities, list_of(:weekly_availability_input)
  end

  object :calendar_queries do
    field :get_calendar, :calendar do
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

    field :update_calendar, :calendar do
      arg :input, non_null(:calendar_input)
      middleware Middleware.Authenticate
      resolve &App.Resolvers.Calendar.update_calendar/3
    end
  end
end
