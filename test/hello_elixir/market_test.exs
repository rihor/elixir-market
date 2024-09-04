defmodule HelloElixir.MarketTest do
  use HelloElixir.DataCase

  alias HelloElixir.Market

  describe "sellers" do
    alias HelloElixir.Market.Seller

    import HelloElixir.MarketFixtures

    @invalid_attrs %{name: nil}

    test "list_sellers/0 returns all sellers" do
      seller = seller_fixture()
      assert Market.list_sellers() == [seller]
    end

    test "get_seller!/1 returns the seller with given id" do
      seller = seller_fixture()
      assert Market.get_seller!(seller.id) == seller
    end

    test "create_seller/1 with valid data creates a seller" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Seller{} = seller} = Market.create_seller(valid_attrs)
      assert seller.name == "some name"
    end

    test "create_seller/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_seller(@invalid_attrs)
    end

    test "update_seller/2 with valid data updates the seller" do
      seller = seller_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Seller{} = seller} = Market.update_seller(seller, update_attrs)
      assert seller.name == "some updated name"
    end

    test "update_seller/2 with invalid data returns error changeset" do
      seller = seller_fixture()
      assert {:error, %Ecto.Changeset{}} = Market.update_seller(seller, @invalid_attrs)
      assert seller == Market.get_seller!(seller.id)
    end

    test "delete_seller/1 deletes the seller" do
      seller = seller_fixture()
      assert {:ok, %Seller{}} = Market.delete_seller(seller)
      assert_raise Ecto.NoResultsError, fn -> Market.get_seller!(seller.id) end
    end

    test "change_seller/1 returns a seller changeset" do
      seller = seller_fixture()
      assert %Ecto.Changeset{} = Market.change_seller(seller)
    end
  end

  describe "products" do
    alias HelloElixir.Market.Product

    import HelloElixir.MarketFixtures

    @invalid_attrs %{name: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Market.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Market.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Product{} = product} = Market.create_product(valid_attrs)
      assert product.name == "some name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Product{} = product} = Market.update_product(product, update_attrs)
      assert product.name == "some updated name"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Market.update_product(product, @invalid_attrs)
      assert product == Market.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Market.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Market.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Market.change_product(product)
    end
  end
end
