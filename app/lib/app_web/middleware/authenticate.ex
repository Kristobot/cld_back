defmodule AppWeb.Middleware.Authenticate do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case Map.get(resolution.context, :current_user) do
      nil ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Authentication required"})
        |> put_http_status(401)

      _user ->
        resolution
    end
  end

  defp put_http_status(res, status_code) do
    %{res | context: Map.put(res.context, :http_status_code, status_code)}
  end
end
