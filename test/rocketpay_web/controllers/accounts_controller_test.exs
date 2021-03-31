defmodule Rocketpay.Users.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Teste",
        password: "test123",
        nickname: "Testando_Create",
        email: "Teste@teste.com",
        age: 30
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic VGVzdDp0ZXN0MTIz")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do

      params = %{"value" => "50.00"}
      response =
      conn
      |> post(Routes.account_path(conn, :deposit, account_id, params))
      |> json_response(:ok)

      assert %{"account" => %{"balance" => "50.00", "id" => _id},
      "message" => "Balance changed successfully"} = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do

      params = %{"value" => "50.0.0"}
      response =
      conn
      |> post(Routes.account_path(conn, :deposit, account_id, params))
      |> json_response(:bad_request)

      assert  %{"message" => "Invalid deposit value!"} = response
    end
  end
end
