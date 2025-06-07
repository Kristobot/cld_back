defmodule AppWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)

  import_types(__MODULE__.User)
  import_types(__MODULE__.Person)

  query do
    import_fields(:user_queries)
  end

  mutation do
    import_fields(:user_mutations)
  end

  # Aplica el middleware a todas las mutations
  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: :mutation}) do
    middleware ++ [AppWeb.Middleware.HandleChangesetErrors]
  end

  # Opcional: Aplicar también a queries si es necesario
  def middleware(middleware, _field, _object), do: middleware
end
