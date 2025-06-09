defmodule App.Resolvers.Patient do

  alias App.Patients

  def create_patient(_parents, %{input: input}, _resolution) do
    case Patients.create_patient(input) do
      {:ok, patient} -> {:ok, patient}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def list_patients(_parents, args, _resolution) do
    case Patients.list_patients(args) do
      {:ok, patients} -> {:ok, patients}
      {:error, changeset} -> {:error, changeset}
    end
  end

end
