defmodule AppWeb.Schema.User do
  use Absinthe.Schema.Notation
  alias AppWeb.Middleware

  object :user do
    field :id, :id
    field :email, :string
    field :role, :string

    field :person, :person

    field :inserted_at, :string
    field :updated_at, :string
  end

  object :token_response do
    field :token, :string
  end

  input_object :user_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :role, non_null(:string)
  end

  input_object :user_with_person_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :role, non_null(:string)
    field :person, non_null(:person_input)
  end

  object :user_mutations do
    field :register, :user do
      arg :input, non_null(:user_input)
      resolve &App.Resolvers.User.register/3
    end

    field :register_with_person, :user do
      arg :input, non_null(:user_with_person_input)
      resolve &App.Resolvers.User.register_with_person/3
    end
  end

  object :user_queries do
    field :login, :token_response do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &App.Resolvers.User.login/3
    end

    field :me, :user do
      middleware Middleware.Authenticate
      resolve &App.Resolvers.User.me/3
    end
  end
end
