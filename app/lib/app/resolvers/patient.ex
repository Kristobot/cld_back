defmodule App.Resolvers.Patient do

  def create_patient(_parents, %{input: input}, _resolution) do
    case App.Patients.create_patient(input) do
      {:ok, patient} -> {:ok, patient}
      {:error, changeset} -> {:error, changeset}
    end
  end

end
