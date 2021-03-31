defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Teste",
        password: "test123",
        nickname: "Testando_Create",
        email: "Teste@teste.com",
        age: 30
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Teste", age: 30, id: ^user_id} = user
    end

    test "when there are invalid params, returns an error" do
      params = %{
        name: "Teste",
        password: "test123",
        nickname: "Testando_Create",
        email: "Testeteste.com",
        age: 14
      }

      {:error, changeset} = Create.call(params)

      expeted_response = %{
        age: ["must be greater than or equal to 18"],
        email: ["has invalid format"]
      }

      assert expeted_response == errors_on(changeset)
    end
  end
end
