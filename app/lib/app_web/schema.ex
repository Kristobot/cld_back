defmodule AppWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)

  import_types(__MODULE__.User)
  import_types(__MODULE__.Person)
  import_types(__MODULE__.ContactMessage)
  import_types(__MODULE__.Patient)
  import_types(__MODULE__.Calendar)
  import_types(__MODULE__.WeeklyAvailability)

  query do
    import_fields(:user_queries)
    import_fields(:contact_message_queries)
    import_fields(:patient_queries)
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:person_mutations)
    import_fields(:contact_message_mutations)
    import_fields(:patient_mutations)
    import_fields(:calendar_mutations)
  end

  # Aplica el middleware a todas las mutations
  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: :mutation}) do
    middleware ++ [AppWeb.Middleware.HandleChangesetErrors]
  end

  # Opcional: Aplicar también a queries si es necesario
  def middleware(middleware, _field, _object), do: middleware
end
