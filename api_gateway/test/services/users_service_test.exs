defmodule ApiGateway.UsersServiceTest do
  use ApiGateway.ConnCase

  alias ApiGateway.UsersService

  describe "when listing users" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == UsersService.list()
    end
  end

  describe "when creating a user" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == UsersService.create(nil)
    end
  end

  describe "when updating a user" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == UsersService.update("mock_id", nil)
    end
  end

  describe "when deleting a user" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == UsersService.delete("mock_id")
    end
  end
end
