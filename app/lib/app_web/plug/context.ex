defmodule AppWeb.Plug.Context do
  import Plug.Conn
  alias AppWeb.Token
  alias App.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    context =
      conn
      |> get_req_header("authorization")
      |> get_user_from_header()

    Absinthe.Plug.put_options(conn, context: context)
  end

  defp get_user_from_header(["Bearer " <> token]) do

    dbg(token)
    with {:ok, claims} <- Token.verify_token(token),
      {:ok, user} <- Accounts.get_user_by_id(claims["id"])
    do
      %{current_user: user}
    else
      _error ->
        %{}
    end
  end

  defp get_user_from_header(_), do: %{}
end
