defmodule App.Accounts.User do
  alias App.Accounts
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string
    field :role, :integer
    field :status, :integer, default: 1

    has_one :person, App.Accounts.Person
    has_one :calendar, App.Scheduling.Calendar

    has_many :appointments, App.Scheduling.Appointment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :role])
    |> validate_required([:email, :password, :role])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email, message: "Email already taken")
    |> hash_password()
    #|> cast_assoc(:person, required: true)
  end

  def register_with_person(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :role])
    |> validate_required([:email, :password, :role])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email, message: "Email already taken")
    |> hash_password()
    |> cast_assoc(:person, with: &Accounts.Person.changeset_person/2)
  end

  def hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Argon2.hash_pwd_salt(pass))
      _ ->
        changeset
    end
  end
end
