defmodule AppWeb.Schema.Person do
  use Absinthe.Schema.Notation

  #import_types Absinthe.Type.Custom

  object :person do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :phone_number, :string
    field :date_of_birth, :date
    field :address, :string
  end

  input_object :person_input do
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :phone_number, non_null(:string)
    field :date_of_birth, non_null(:date)
    field :address, non_null(:string)
  end
end
