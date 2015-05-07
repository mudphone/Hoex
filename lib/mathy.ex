defmodule Mathy do
  def no_op, do: :ok
  def inc(a), do: a + 1
  def div(a, b), do: a / b
  def div(a, b, c), do: a / b / c
  def div(a, b, c, d), do: a / b / c / d
  def div(a, b, c, d, e), do: a / b / c / d / e
  def add(a, b), do: a + b
  def mul(a, b), do: a * b
  def dbl(a), do: a * 2
end