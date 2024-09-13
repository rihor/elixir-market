defmodule HelloElixir.Market do
  @moduledoc """
  The Market context.
  """

  import Ecto.Query, warn: false
  alias HelloElixir.Market.OrderProduct
  alias HelloElixir.Repo

  alias HelloElixir.Market.Customer

  alias HelloElixir.Market.Product

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(HelloElixir.PubSub, @topic)
  end

  def subscribe(session_id) do
    Phoenix.PubSub.subscribe(HelloElixir.PubSub, @topic <> "#{session_id}")
  end

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:product, :added])
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_customer(attrs) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end

  def update_customer(%Customer{} = customer, attrs) do
    customer
    |> Customer.changeset(attrs)
    |> Repo.update()
  end

  alias HelloElixir.Market.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:order, :added])
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  def get_active_order(nil = _customer_id, nil = _session_id), do: nil

  @spec get_active_order(integer(), binary()) :: %Order{}
  def get_active_order(customer_id, session_id) do
    query =
      from(o in Order,
        where: o.status == ^:shopping,
        limit: 1
      )

    query =
      if customer_id do
        from(o in query, where: o.customer_id == ^customer_id)
      else
        query
      end

    query =
      from(o in query, where: o.logged_out_session == ^session_id)

    case Repo.one(query) do
      nil ->
        create_order(%{customer_id: customer_id, logged_out_session: session_id})

      order ->
        order
    end
  end

  def get_active_order_with_products(customer_id, session_id) do
    get_active_order(customer_id, session_id) |> Repo.preload(order_products: [:product])
  end

  def create_or_increment_order_product(attrs) do
    %OrderProduct{}
    |> OrderProduct.changeset(attrs)
    |> Repo.insert(conflict_target: [:order_id, :product_id], on_conflict: [inc: [quantity: 1]])
    |> notify_subscribers([:order_product, :added])
  end

  @spec add_product_to_order(integer(), integer(), binary()) :: %OrderProduct{}
  def add_product_to_order(product_id, customer_id, session_id) do
    Repo.transaction(fn ->
      # get the active order
      order = get_active_order(customer_id, session_id)

      create_or_increment_order_product(%{order_id: order.id, product_id: product_id})
      |> IO.inspect(label: "order_product")
    end)
  end

  defp notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(
      HelloElixir.PubSub,
      @topic,
      {__MODULE__, event, result}
    )

    Phoenix.PubSub.broadcast(
      HelloElixir.PubSub,
      @topic <> "#{result.id}",
      {__MODULE__, event, result}
    )

    {:ok, result}
  end

  defp notify_subscribers({:error, reason}), do: {:error, reason}
end
