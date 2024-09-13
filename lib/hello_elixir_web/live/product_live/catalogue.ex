defmodule HelloElixirWeb.ProductLive.Catalogue do
  alias Phoenix.PubSub
  use HelloElixirWeb, :live_view

  alias HelloElixir.Market

  @topic inspect(Market)

  @impl true
  def mount(_params, session, socket) do
    socket = assign(socket, :crsf_token, session["_csrf_token"])

    if connected?(socket), do: PubSub.subscribe(HelloElixir.PubSub, @topic)

    {:ok, stream(socket, :products, Market.list_products())}
  end

  @impl true
  def handle_info({Market, [:product, :added], product}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_info(_msg, socket) do
    # Ignore the message and return the socket unchanged
    {:noreply, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Market.list_products())}
  end

  @impl true
  def handle_event("add_product_to_order", params, socket) do
    customer_id =
      case socket.assigns[:current_user] do
        %{} = current_user -> current_user.customer_id
        _ -> nil
      end

    # adicionar na order o produto selecionado
    Market.add_product_to_order(
      params["product-id"],
      customer_id,
      socket.assigns[:crsf_token]
    )

    # designar um tempo de expiracao da order
    # mandar um sinal pra alertar que um produto foi adicionado a order
    {:noreply, socket}
  end

  defp page_title(:catalogue), do: "Catalogue"
end
