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

  def list_patients(args) do
    args
    |> patient_query()
    |> Repo.all()
    |> case do
      [] -> {:ok, []}
      patients -> {:ok, patients}
    end
  end

  defp patient_query(args) do
    Enum.reduce(args, Patient, fn
      {:filter, filter}, query ->
        query |> patient_filter(filter)
    end)
  end

  defp patient_filter(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:first_name, first_name}, query ->
        query_like = "%#{first_name}%"
        from(q in query, where: like(q.first_name, ^query_like))
      {:last_name, last_name}, query ->
        query_like = "%#{last_name}%"
        from(q in query, where: like(q.last_name, ^query_like))
      {:gender, gender}, query ->
        if gender != nil do
          from(q in query, where: q.gender == ^gender)
        else
          query
        end
      {:email, email}, query ->
        from(q in query, where: q.email == ^email)
      {:status, status}, query ->
        from(q in query, where: q.status == ^status)
    end)
  end
end
