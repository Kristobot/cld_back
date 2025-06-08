defmodule App.Repo.Migrations.CreateContactMessage do
  use Ecto.Migration

  def up do
    create table(:contact_messages) do
      add :name, :string
      add :email, :string
      add :phone_number, :string
      add :issue, :string
      add :contact_method, :integer, default: 0
      add :status, :integer, default: 0
      timestamps()
    end
  end

  def down do
    drop table(:contact_messages)
  end
end
