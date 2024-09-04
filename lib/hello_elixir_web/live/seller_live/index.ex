defmodule HelloElixirWeb.SellerLive.Index do
  use HelloElixirWeb, :live_view

  alias HelloElixir.Market
  alias HelloElixir.Market.Seller

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :sellers, Market.list_sellers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Seller")
    |> assign(:seller, Market.get_seller!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Seller")
    |> assign(:seller, %Seller{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sellers")
    |> assign(:seller, nil)
  end

  @impl true
  def handle_info({HelloElixirWeb.SellerLive.FormComponent, {:saved, seller}}, socket) do
    {:noreply, stream_insert(socket, :sellers, seller)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    seller = Market.get_seller!(id)
    {:ok, _} = Market.delete_seller(seller)

    {:noreply, stream_delete(socket, :sellers, seller)}
  end
end
