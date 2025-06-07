defmodule App.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Accounts.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
