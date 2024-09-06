defmodule HelloElixir.MarketFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HelloElixir.Market` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> HelloElixir.Market.create_product()

    product
  end

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{

      })
      |> HelloElixir.Market.create_order()

    order
  end
end
