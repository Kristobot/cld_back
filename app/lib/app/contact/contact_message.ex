defmodule App.Contact.ContactMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contact_messages" do
    field :name, :string
    field :email, :string
    field :phone_number, :string
    field :issue, :string
    field :contact_method, :integer, default: 0
    field :status, :integer, default: 0
    timestamps()
  end

  def changeset(contact_message, attrs) do
    contact_message
    |> cast(attrs, [:name, :email, :phone_number, :issue, :status])
    |> validate_required([:name, :email, :phone_number, :issue, :status])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
  end
end
