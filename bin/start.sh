#!/bin/bash

if [ ! -d "/app/_build" ]
then
    # Download Dependencies
    mix deps.get
    # Compile Dependencies
    mix compile
    # Setup DB
    # mix ecto.setup
fi

echo "Run Phoenix Server"
elixir --sname node --cookie fractalup -S mix phx.server