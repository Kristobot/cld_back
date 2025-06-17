defmodule App.Resolvers.Calendar do

  alias App.Scheduling

  def create_calendar(_parents, %{input: input}, %{context: %{current_user: user}}) do
    input = Map.put(input, :dentist_id, user.id)
    case Scheduling.create_calendar(input) do
      {:ok, calendar} -> {:ok, calendar}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def get_calendar(_parents, _args, %{context: %{current_user: user}}) do
    case Scheduling.get_calendar_by_dentist(user.id) do
      {:ok, calendar} -> {:ok, calendar}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def update_calendar(_parents, %{input: input}, %{context: %{current_user: user}}) do
    with {:ok, calendar} <- Scheduling.get_calendar_by_dentist(user.id),
      true <- is_my_calendar?(calendar.dentist_id, user.id),
      {:ok, calendar} <- Scheduling.update_calendar(calendar, input)
    do
      {:ok, calendar}
    else
      false -> {:error, "You are not allowed to update this calendar"}
      {:error, :not_found} -> {:error, "Calendar not found"}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp is_my_calendar?(dentist_id, user_id) do
    dentist_id == user_id
  end
end
