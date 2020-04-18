defmodule ApiGateway.TournamentsServiceTest do
  use ApiGateway.ConnCase

  alias ApiGateway.TournamentsService

  describe "when listing tournaments" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == TournamentsService.list()
    end
  end

  describe "when creating a tournament" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == TournamentsService.create(nil)
    end
  end

  describe "when updating a tournament" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == TournamentsService.update("mock_id", nil)
    end
  end

  describe "when deleting a tournament" do
    test "should raise a NotImplemented error" do
      assert {:error, %{reason: "NotImplemented"}} == TournamentsService.delete("mock_id")
    end
  end
end
