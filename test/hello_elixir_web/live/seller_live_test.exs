defmodule HelloElixirWeb.SellerLiveTest do
  use HelloElixirWeb.ConnCase

  import Phoenix.LiveViewTest
  import HelloElixir.MarketFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_seller(_) do
    seller = seller_fixture()
    %{seller: seller}
  end

  describe "Index" do
    setup [:create_seller]

    test "lists all sellers", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/sellers")

      assert html =~ "Listing Sellers"
    end

    test "saves new seller", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sellers")

      assert index_live |> element("a", "New Seller") |> render_click() =~
               "New Seller"

      assert_patch(index_live, ~p"/sellers/new")

      assert index_live
             |> form("#seller-form", seller: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#seller-form", seller: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sellers")

      html = render(index_live)
      assert html =~ "Seller created successfully"
    end

    test "updates seller in listing", %{conn: conn, seller: seller} do
      {:ok, index_live, _html} = live(conn, ~p"/sellers")

      assert index_live |> element("#sellers-#{seller.id} a", "Edit") |> render_click() =~
               "Edit Seller"

      assert_patch(index_live, ~p"/sellers/#{seller}/edit")

      assert index_live
             |> form("#seller-form", seller: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#seller-form", seller: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sellers")

      html = render(index_live)
      assert html =~ "Seller updated successfully"
    end

    test "deletes seller in listing", %{conn: conn, seller: seller} do
      {:ok, index_live, _html} = live(conn, ~p"/sellers")

      assert index_live |> element("#sellers-#{seller.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sellers-#{seller.id}")
    end
  end

  describe "Show" do
    setup [:create_seller]

    test "displays seller", %{conn: conn, seller: seller} do
      {:ok, _show_live, html} = live(conn, ~p"/sellers/#{seller}")

      assert html =~ "Show Seller"
    end

    test "updates seller within modal", %{conn: conn, seller: seller} do
      {:ok, show_live, _html} = live(conn, ~p"/sellers/#{seller}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Seller"

      assert_patch(show_live, ~p"/sellers/#{seller}/show/edit")

      assert show_live
             |> form("#seller-form", seller: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#seller-form", seller: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sellers/#{seller}")

      html = render(show_live)
      assert html =~ "Seller updated successfully"
    end
  end
end
