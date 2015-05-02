defmodule Hoex do

  def arity(f) do
    {:arity, n} = :erlang.fun_info(f, :arity)
    n
  end

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
    case arity(g) do
      0 -> fn -> f.(g.()) end
      1 -> fn a -> f.(g.(a)) end
      2 -> fn a, b -> f.(g.(a,b)) end
      3 -> fn a, b, c -> f.(g.(a,b,c)) end
      4 -> fn a, b, c, d -> f.(g.(a,b,c,d)) end
      5 -> fn a, b, c, d, e -> f.(g.(a,b,c,d,e)) end
    end
  end
  def comp(f, g, h), do: comp(f, comp(g, h))
  def comp(f, g, h, i), do: comp(f, g, comp(h, i))
  def comp(f, g, h, i, j), do: comp(f, g, h, comp(i, j))

  def flip(f) do
    fn a, b ->
      f.(b, a)
    end
  end

  def partial(f, a), do: curry(f).(a)
  def partial(f, a, b), do: curry(f).(a).(b)
  def partial(f, a, b, c), do: curry(f).(a).(b).(c)
  def partial(f, a, b, c, d), do: curry(f).(a).(b).(c).(d)
end
