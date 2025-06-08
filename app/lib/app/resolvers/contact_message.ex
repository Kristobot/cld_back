defmodule App.Resolvers.ContactMessage do
  alias App.Contact
  def create_contact_message(_parents, %{input: input}, _resolution) do
    case Contact.create_contact_message(input) do
      {:ok, contact_message} -> {:ok, contact_message}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def list_contact_messages(_parents, args, _resolution) do
    case Contact.list_contact_messages(args) do
      {:ok, contact_messages} -> {:ok, contact_messages}
      {:error, changeset} -> {:error, changeset}
    end
  end

end
