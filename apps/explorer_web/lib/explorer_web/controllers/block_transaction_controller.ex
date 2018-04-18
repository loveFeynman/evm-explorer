defmodule ExplorerWeb.BlockTransactionController do
  use ExplorerWeb, :controller

  import ExplorerWeb.Chain, only: [param_to_block_number: 1]

  alias Explorer.Chain

  def index(conn, %{"block_id" => formatted_block_number} = params) do
    with {:ok, block_number} <- param_to_block_number(formatted_block_number),
         {:ok, block} <- Chain.number_to_block(block_number) do
      page =
        Chain.block_to_transactions(
          block,
          necessity_by_association: %{
            block: :required,
            from_address: :required,
            to_address: :required,
            receipt: :required
          },
          pagination: params
        )

      render(conn, "index.html", page: page)
    else
      {:error, :invalid} ->
        not_found(conn)

      {:error, :not_found} ->
        not_found(conn)
    end
  end
end
