defmodule HelloElixirWeb.ProductLive.Catalogue do
  use HelloElixirWeb, :live_view

  alias HelloElixir.Market

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :products, Market.list_products())}
  end

  @impl true
  def handle_info({:product_added, product}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Market.list_products())}
  end

  defp page_title(:catalogue), do: "Catalogue"
end
