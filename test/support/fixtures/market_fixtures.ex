defmodule HelloElixir.MarketFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HelloElixir.Market` context.
  """

  @doc """
  Generate a seller.
  """
  def seller_fixture(attrs \\ %{}) do
    {:ok, seller} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> HelloElixir.Market.create_seller()

    seller
  end

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
end
