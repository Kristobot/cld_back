defmodule AppWeb.Schema.ContactMessage do
  use Absinthe.Schema.Notation
  alias AppWeb.Middleware

  object :contact_message do
    field :id, :id
    field :name, :string
    field :email, :string
    field :phone_number, :string
    field :issue, :string
    field :contact_method, :integer
    field :status, :string
    field :inserted_at, :string
    field :updated_at, :string
  end

  input_object :contact_message_input do
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :phone_number, non_null(:string)
    field :issue, non_null(:string)
  end

  input_object :contact_message_filter do
    field :id, :id
    field :email, :string
    field :status, :integer
    field :name, :string
    field :contact_method, :integer
  end

  object :contact_message_queries do
    field :list_contact_messages, list_of(:contact_message) do
      arg :filter, non_null(:contact_message_filter)
      middleware Middleware.Authenticate
      resolve &App.Resolvers.ContactMessage.list_contact_messages/3
    end
  end

  object :contact_message_mutations do
    field :create_contact_message, :contact_message do
      arg :input, non_null(:contact_message_input)
      resolve &App.Resolvers.ContactMessage.create_contact_message/3
    end
  end
end
