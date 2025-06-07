defmodule App.Accounts.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field :first_name, :string
    field :last_name, :string
    field :phone_number, :string
    field :date_of_birth, :date
    field :address, :string

    belongs_to :user, App.Accounts.User

    timestamps()
  end

  def changeset(person, attrs) do
    person
    |> cast(attrs, [:first_name, :last_name, :phone_number, :date_of_birth, :address, :user_id])
    |> validate_required([:first_name, :last_name, :phone_number, :date_of_birth, :address, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
