defmodule AppWeb.Schema.Appointment do
  use Absinthe.Schema.Notation
  alias AppWeb.Middleware

  object :appointment do
    field :id, :id
    field :status, :integer
    field :reason, :string
    field :notes, :string
    field :start_time, :datetime
    field :end_time, :datetime
    field :dentist, :user
    field :patient, :patient
    field :scheduler, :user
    field :inserted_at, :string
    field :updated_at, :string
  end

  input_object :appointment_input do
    field :status, non_null(:integer)
    field :reason, non_null(:string)
    field :notes, non_null(:string)
    field :start_time, non_null(:datetime)
    field :end_time, non_null(:datetime)
    field :dentist_id, non_null(:id)
    field :patient_id, non_null(:id)
  end

  object :appointment_mutations do
    field :create_appointment, :appointment do
      arg :input, non_null(:appointment_input)
      middleware Middleware.Authenticate
      resolve &App.Resolvers.Appointment.create_appointment/3
    end
  end
end
