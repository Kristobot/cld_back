defmodule AppWeb.Middleware.HandleChangesetErrors do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.errors do
      [%Ecto.Changeset{} = changeset | _] ->
        formatted_errors = format_errors(changeset)
        %{resolution | errors: formatted_errors}
      _ ->
        resolution
    end
  end

  defp format_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {field, message} ->
      %{
        message: "Validation error",
        details: %{field: to_string(field), reason: message},
        extensions: %{code: "VALIDATION_ERROR"}
      }
    end)
  end

end
