defmodule Rocketpay.Numbers do
  def sum_from_file(filename) do
    "#{filename}.csv"
    |> File.read()
    |> handle_file()
  end

  defp handle_file({:ok, result}) do
    result =
    result
    |> String.split(",")
    |> Stream.map(fn num -> String.to_integer(num) end)
    |> Enum.sum()

    {:ok, %{result: result}}
  end
  defp handle_file({:error, _reason}), do: {:error, %{message: "Invalid File!"}}
end
