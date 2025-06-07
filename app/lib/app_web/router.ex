defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug :accepts, ["json"]
    plug AppWeb.Plug.Context
  end

  # Endpoint principal GraphQL
  scope "/api" do
    pipe_through :graphql

    if Mix.env() == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: AppWeb.Schema,
        interface: :simple
    end

    forward "/", Absinthe.Plug,
      schema: AppWeb.Schema

  end

end
