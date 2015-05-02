defmodule Hoex do

  def arity(f) when is_function(f), do: arity(f, 0)
  defp arity(f, n) when is_function(f, n), do: n
  defp arity(f, n), do: arity(f, n+1)

  defp curryize(f, 0, args) do
    apply(f, args)
  end

  defp curryize(f, n, args) do
    fn x ->
      curryize(f, n-1, args ++ [x])
    end
  end

  def curry(f) do
    case n = arity(f) do
      0 -> f
      _ -> curryize(f, n, [])
    end
  end

  def comp(f, g) do
    fn a, b ->
      f.(g.(a, b))
    end
  end
end
