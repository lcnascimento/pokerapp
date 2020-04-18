defmodule ApiGateway.ClubsServiceTest do
  use ApiGateway.ConnCase

  alias ApiGateway.ClubsService
  alias ApiGateway.ClubsService.Members
  alias ApiGateway.ClubsService.Staff

  describe "when listing clubs" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == ClubsService.list()
    end
  end

  describe "when creating a club" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == ClubsService.create(nil)
    end
  end

  describe "when updating a club" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == ClubsService.update("mock_id", nil)
    end
  end

  describe "when deleting a club" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == ClubsService.delete("mock_id")
    end
  end

  describe "when listing club's members" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == Members.list("mock_id")
    end
  end

  describe "when addind a member into club" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == Members.create("mock_id", nil)
    end
  end

  describe "when deleting a member from club" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == Members.delete("mock_id", "member_mock_id")
    end
  end

  describe "when listing club's staff" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == Staff.list("mock_id")
    end
  end

  describe "when addind an employee into club" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == Staff.create("mock_id", nil)
    end
  end

  describe "when deleting an employee from club" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == Staff.delete("mock_id", "member_mock_id")
    end
  end
end
