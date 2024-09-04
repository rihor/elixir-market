defmodule HelloElixirWeb.SellerLive.FormComponent do
  use HelloElixirWeb, :live_component

  alias HelloElixir.Market

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage seller records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="seller-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Seller</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{seller: seller} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Market.change_seller(seller))
     end)}
  end

  @impl true
  def handle_event("validate", %{"seller" => seller_params}, socket) do
    changeset = Market.change_seller(socket.assigns.seller, seller_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"seller" => seller_params}, socket) do
    save_seller(socket, socket.assigns.action, seller_params)
  end

  defp save_seller(socket, :edit, seller_params) do
    case Market.update_seller(socket.assigns.seller, seller_params) do
      {:ok, seller} ->
        notify_parent({:saved, seller})

        {:noreply,
         socket
         |> put_flash(:info, "Seller updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_seller(socket, :new, seller_params) do
    case Market.create_seller(seller_params) do
      {:ok, seller} ->
        seller |> dbg()
        notify_parent({:saved, seller})

        {:noreply,
         socket
         |> put_flash(:info, "Seller created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
