defmodule App.Contact do
  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Contact.ContactMessage

  def create_contact_message(attrs \\ %{}) do
    %ContactMessage{}
    |> ContactMessage.changeset(attrs)
    |> Repo.insert()
  end

  def list_contact_messages(args) do
    args
    |> contact_message_query()
    |> Repo.all()
    |> case do
      [] -> {:ok, []}
      contact_messages -> {:ok, contact_messages}
    end
  end

  defp contact_message_query(args) do
    Enum.reduce(args, ContactMessage, fn
      {:filter, filter}, query ->
        query |> contact_message_filter(filter)
    end)
  end

  defp contact_message_filter(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:name, name}, query ->
        from(q in query, where: q.name == ^name)
      {:email, email}, query ->
        from(q in query, where: q.email == ^email)
      {:phone_number, phone_number}, query ->
        from(q in query, where: q.phone_number == ^phone_number)
      {:issue, issue}, query ->
        from(q in query, where: q.issue == ^issue)
      {:status, status}, query ->
        from(q in query, where: q.status == ^status)
      {:contact_method, contact_method}, query ->
        from(q in query, where: q.contact_method == ^contact_method)
    end)
  end
end
