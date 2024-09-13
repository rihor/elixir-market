defmodule HelloElixirWeb.CartComponent do
  alias Ecto.Repo
  use HelloElixirWeb, :live_component

  alias HelloElixir.Market

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div :if={@quantity}>
        Carrinho <%= @quantity %>
        <div :for={{id, order_product} <- @streams.order_products} id={id}>
          <%= order_product.product.name %>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    customer_id = assigns[:current_user] && assigns[:current_user].customer_id
    session_id = assigns[:session_id]

    order =
      Market.get_active_order_with_products(customer_id, session_id)
      |> IO.inspect()

    {:ok,
     socket
     |> assign(:quantity, order.order_products |> Enum.map(& &1.quantity) |> Enum.sum())
     |> stream(:order_products, order.order_products)}
  end
end
