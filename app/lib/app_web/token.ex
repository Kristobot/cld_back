defmodule AppWeb.Token do
  use Joken.Config
  require Logger

  @impl true
  def token_config do
    default_claims()
  end

  def generate_token(user) do

    extra_claims = %{
      "role" => user.role,
      "email" => user.email,
      "id" => user.id
    }

    __MODULE__
    .generate_and_sign(extra_claims)
    |> case do
      {:ok, token, _claims} -> {:ok, token}
      _error -> {:error, :invalid_token}
    end
  end

  def verify_token(token) do
    __MODULE__
    .verify_and_validate(token)
  end
end
