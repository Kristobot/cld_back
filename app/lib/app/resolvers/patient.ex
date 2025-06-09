defmodule App.Resolvers.Patient do

  alias App.Patients

  def create_patient(_parents, %{input: input}, _resolution) do
    case Patients.create_patient(input) do
      {:ok, patient} -> {:ok, patient}
      {:error, changeset} -> {:error, changeset}
    end
  end

end
