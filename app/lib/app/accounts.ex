defmodule App.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Accounts.{User, Person}

  @role %{admin: 0, dentist: 1, receptionist: 2, nurse: 3}

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def is_dentist?(user_id) do
    case Repo.get(User, user_id) do
      nil -> {:error, :not_found}
      user -> user.role == @role.dentist
    end
  end

  def create_user_with_person(attrs \\ %{}) do
    %User{}
    |> User.register_with_person(attrs)
    |> Repo.insert()
  end

  def get_user_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def get_user_by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def get_user_by_id(id, :preload) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user ->
        user = Repo.preload(user, :person)
        {:ok, user}
    end
  end

  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  def list_users(args) do
    args
    |> user_query()
    |> preload(:person)
    |> Repo.all()
    |> case do
      [] -> {:ok, []}
      users -> {:ok, users}
    end
  end

  def user_query(args) do
    Enum.reduce(args, User, fn
      {:filter, filter}, query -> query |> user_filter(filter)
    end)
  end

  defp user_filter(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:email, email}, query ->
        from(q in query, where: q.email == ^email)
      {:role, role}, query ->
        from(q in query, where: q.role == ^role)
      {:status, status}, query ->
        from(q in query, where: q.status == ^status)
    end)
  end
end
