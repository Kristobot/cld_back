# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     App.Repo.insert!(%App.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

user =
  %{
    email: "test@gmail.com",
    password: "test456123",
    role: 0,
    person: %{
      first_name: "Test",
      last_name: "User",
      address: "123 Test Street",
      phone_number: "123456789",
      date_of_birth: "2000-01-01",
      specialty: 0
    }
  }

App.Accounts.create_user_with_person(user)
