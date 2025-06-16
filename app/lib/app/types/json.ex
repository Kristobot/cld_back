defmodule App.Types.Json do
  use Ecto.ParameterizedType

  def type(_params), do: :string

  def init(opts) do
    schema = Keyword.get(opts, :struct, :map)
    default = Keyword.get(opts, :default, nil)
    %{struct: schema, default: default}
  end

  def cast(nil, %{default: default}), do: {:ok, default}

  def cast(data, %{struct: schema}) do
    cond do
      is_struct(data, schema) ->
        {:ok, data}

      is_map(data) || is_list(data) ->
        convert_to_schema(data, schema)

      true ->
        :error
    end
  end

  def cast(_, _), do: :error

  def load(nil, _function, %{default: default}), do: {:ok, default}
  def load(json, _function, %{struct: schema}) when is_binary(json) do
    case Jason.decode(json) do
      {:ok, decoded} -> convert_to_schema(decoded, schema)
      _ -> :error
    end
  end

  def dump(nil, _function, %{default: default}), do: {:ok, default}
  def dump(data, _function, %{struct: schema}) do
    case prepare_for_dump(data, schema) do
      {:ok, prepared} -> Jason.encode(prepared)
      error -> error
    end
  end

  # Funciones auxiliares mejoradas para embedded schemas
  defp convert_to_schema(nil, _schema), do: {:ok, nil}
  defp convert_to_schema(data, :map), do: {:ok, data}

  defp convert_to_schema(data, schema) when is_map(data) do
    try do
      # Conversión especial para embedded schemas
      {:ok, Ecto.embedded_load(schema, data, :json)}
    rescue
      _ -> :error
    end
  end

  defp convert_to_schema(data, schema) when is_list(data) do
    converted =
      Enum.map(data, fn item ->
        if is_map(item) do
          try do
            Ecto.embedded_load(schema, item, :json)
          rescue
            _ -> item
          end
        else
          item
        end
      end)

    {:ok, converted}
  end

  defp convert_to_schema(_, _), do: :error

  defp prepare_for_dump(nil, _schema), do: {:ok, nil}
  defp prepare_for_dump(data, schema) when is_struct(data, schema) do
    # Conversión especial para embedded schemas
    {:ok, Ecto.embedded_dump(data, :json)}
  end

  defp prepare_for_dump(data, schema) when is_list(data) do
    converted =
      Enum.map(data, fn
        item when is_struct(item, schema) -> Ecto.embedded_dump(item, :json)
        item -> item
      end)

    {:ok, converted}
  end

  defp prepare_for_dump(data, :map) when is_map(data) or is_list(data), do: {:ok, data}
  defp prepare_for_dump(_, _), do: :error
end
