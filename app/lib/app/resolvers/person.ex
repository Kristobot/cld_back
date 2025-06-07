defmodule App.Resolvers.Person do
  alias App.Accounts

  def create_person(_parents, %{input: input}, %{context: %{current_user: user}}) do

    input = Map.put(input, :user_id, user.id)

    case Accounts.create_person(input) do
      {:ok, person} -> {:ok, person}
      {:error, changeset} -> {:error, changeset}
    end

  end
end
