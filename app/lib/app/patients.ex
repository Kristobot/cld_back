defmodule App.Patients do
  @moduledoc """
  The Patiens context.
  """

  import Ecto.Query, warn: false
  alias App.Repo
  alias App.Patients.Patient

  def create_patient(attrs \\ %{}) do
    %Patient{}
    |> Patient.changeset(attrs)
    |> Repo.insert()
  end
end
