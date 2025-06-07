defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug :accepts, ["json"]
  end

  # Desarrollo: GraphiQL
  if Mix.env() == :dev do
    scope "/" do
      pipe_through :graphql

      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: AppWeb.Schema # Solo si usas subscriptions
    end
  end

  # Endpoint principal GraphQL
  scope "/api" do
    pipe_through :graphql

    forward "/", Absinthe.Plug,
      schema: AppWeb.Schema
  end
end
