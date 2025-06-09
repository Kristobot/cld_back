defmodule App.Patients.Patient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "patients" do
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

    timestamps()
  end

  def changeset(patient, attrs) do
    patient
    |> cast(attrs, [:first_name, :last_name, :birth_date, :gender, :phone_number, :email, :address, :city, :postal_code, :occupation, :emergency_contact, :emergency_phone, :status])
    |> validate_required([:first_name, :last_name, :birth_date, :gender, :phone_number, :email, :address, :city, :postal_code, :occupation, :emergency_contact, :emergency_phone,:status])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email, message: "Email already taken")
  end
end
