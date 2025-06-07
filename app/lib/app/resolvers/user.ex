defmodule App.Resolvers.User do
  alias App.Accounts
  alias AppWeb.Token

  def register(_parents, %{input: params}, _resolution) do
    case Accounts.create_user(params) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def login(_parents, %{email: email, password: password}, _resolution) do
    with {:ok, user} <- Accounts.get_user_by_email(email),
      true <- Argon2.verify_pass(password, user.password),
      {:ok, token} <- Token.generate_token(user)
    do
      {:ok, %{token: token}}
    else
      {:error, :not_found} -> {:error, "User not found"}
      false -> {:error, "Invalid password"}
      {:error, :invalid_token} -> {:error, "Invalid token"}
    end
  end

  def me(_parents, _args, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def register_with_person(_parents, %{input: input}, _resolution) do
    case Accounts.create_user_with_person(input) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
