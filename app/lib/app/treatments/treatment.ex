defmodule App.Treatments.Treatment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "treatments" do
    field :name, :string
    field :description, :string
    field :start_date, :date
    field :end_date, :date
    field :status, :integer
    field :cost, :decimal

    timestamps()
  end
end
