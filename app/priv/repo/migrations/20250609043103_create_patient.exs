defmodule App.Repo.Migrations.CreatePatient do
  use Ecto.Migration

  def up do
    create table(:patients) do
      add :first_name, :string
      add :last_name, :string
      add :birth_date, :date
      add :gender, :integer
      add :phone_number, :string
      add :email, :string
      add :address, :string
      add :city, :string
      add :postal_code, :string
      add :occupation, :string
      add :emergency_contact, :string
      add :emergency_phone, :string
      add :registration_date, :date
      add :status, :integer, default: 1
      timestamps()
    end

    create unique_index(:patients, [:email])
  end

  def down do
    drop table(:patients)
  end
end
