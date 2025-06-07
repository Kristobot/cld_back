defmodule App.Accounts.User do
  alias App.Accounts
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string
    field :role, Ecto.Enum, values: [admin: 0, doctor: 1, receptionist: 2, nurse: 3]

    has_one :person, App.Accounts.Person

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :role])
    |> validate_required([:email, :password, :role])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email)
    |> hash_password()
    #|> cast_assoc(:person, required: true)
  end

  def register_with_person(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :role])
    |> validate_required([:email, :password, :role])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email)
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
