defmodule Tupile.Core.Purchase do
  defstruct type: nil,
            amount: nil

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
