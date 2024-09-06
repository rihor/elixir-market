defmodule HelloElixir.MarketTest do
  use HelloElixir.DataCase

  alias HelloElixir.Market

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

  describe "orders" do
    alias HelloElixir.Market.Order

    import HelloElixir.MarketFixtures

    @invalid_attrs %{}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Market.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Market.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{}

      assert {:ok, %Order{} = order} = Market.create_order(valid_attrs)
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{}

      assert {:ok, %Order{} = order} = Market.update_order(order, update_attrs)
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Market.update_order(order, @invalid_attrs)
      assert order == Market.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Market.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Market.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Market.change_order(order)
    end
  end
end
