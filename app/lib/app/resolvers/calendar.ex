defmodule App.Resolvers.Calendar do

  alias App.Scheduling

  def create_calendar(_parents, %{input: input}, %{context: %{current_user: user}}) do
    input = Map.put(input, :dentist_id, user.id)
    case Scheduling.create_calendar(input) do
      {:ok, calendar} -> {:ok, calendar}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def get_calendar(_parents, %{id: id}, _resolution) do
    case Scheduling.get_calendar(id) do
      {:ok, calendar} -> {:ok, calendar}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
