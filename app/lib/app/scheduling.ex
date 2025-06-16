defmodule App.Scheduling do
  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Scheduling.{Calendar, Appointment}

  def create_calendar(attrs \\ %{}) do
    %Calendar{}
    |> Calendar.changeset(attrs)
    |> Repo.insert()
  end

  def get_calendar(id) do
    case Repo.get(Calendar, id) do
      nil -> {:error, :not_found}
      calendar -> {:ok, calendar}
    end
  end
end
