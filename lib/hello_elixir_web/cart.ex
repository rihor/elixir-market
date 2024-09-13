defmodule HelloElixirWeb.Cart do
  import Plug.Conn

  alias HelloElixir.Repo
  alias HelloElixir.Market

  def fetch_cart(conn, _opts) do
    customer_id = conn.assigns[:current_user] && conn.assigns[:current_user].customer_id
    session_id = get_session(conn) |> Map.get("_csrf_token")
    cart = Market.get_active_order(customer_id, session_id)

    cart_with_products = cart |> Repo.preload(order_products: [:product])

    conn |> assign(:cart, cart_with_products) |> dbg
  end
end
