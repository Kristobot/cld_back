defmodule AppWeb.Schema.Patient do
  use Absinthe.Schema.Notation
  alias AppWeb.Middleware

  object :patient do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :birth_date, :date
    field :gender, :integer
    field :phone_number, :string
    field :email, :string
    field :address, :string
    field :city, :string
    field :postal_code, :string
    field :occupation, :string
    field :emergency_contact, :string
    field :emergency_phone, :string
    field :status, :integer
    field :inserted_at, :string
    field :updated_at, :string
  end

  input_object :patient_input do
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :birth_date, non_null(:date)
    field :gender, non_null(:integer)
    field :phone_number, non_null(:string)
    field :email, non_null(:string)
    field :address, non_null(:string)
    field :city, non_null(:string)
    field :postal_code, non_null(:string)
    field :occupation, non_null(:string)
    field :emergency_contact, non_null(:string)
    field :emergency_phone, non_null(:string)
  end

  input_object :patient_filter do
    field :id, :id
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :status, :integer
    field :gender, :integer
  end

  object :patient_mutations do
    field :create_patient, :patient do
      arg :input, non_null(:patient_input)
      middleware Middleware.Authenticate
      resolve &App.Resolvers.Patient.create_patient/3
    end
  end

  object :patient_queries do
    field :list_patients, list_of(:patient) do
      arg :filter, non_null(:patient_filter)
      middleware Middleware.Authenticate
      resolve &App.Resolvers.Patient.list_patients/3
    end
  end
end
