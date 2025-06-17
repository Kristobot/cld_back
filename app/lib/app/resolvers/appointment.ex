defmodule App.Resolvers.Appointment do
  alias App.Scheduling


  def create_appointment(_parents, %{input: input}, %{context: %{current_user: user}}) do
    input = Map.put(input, :scheduler_id, user.id)
    with true <- Scheduling.is_available?(input.dentist_id, input.start_time, input.end_time),
      {:ok, appointment} <- Scheduling.create_appointment(input)
    do
      {:ok, appointment}
    else
      false -> {:error, "Appointment is not available"}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
