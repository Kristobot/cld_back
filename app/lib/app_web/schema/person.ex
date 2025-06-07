defmodule AppWeb.Schema.Person do
  use Absinthe.Schema.Notation
  alias AppWeb.Middleware

  #import_types Absinthe.Type.Custom

  object :person do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :phone_number, :string
    field :date_of_birth, :date
    field :address, :string
    field :user_id, :id
    field :specialty, :integer

    field :user, :user

    field :inserted_at, :string
    field :updated_at, :string
  end

  input_object :person_input do
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :phone_number, non_null(:string)
    field :date_of_birth, non_null(:date)
    field :address, non_null(:string)
    field :specialty, non_null(:string)
  end

  object :person_mutations do
    field :create_person, :person do
      arg :input, non_null(:person_input)
      middleware Middleware.Authenticate
      resolve &App.Resolvers.Person.create_person/3
    end
  end
end
