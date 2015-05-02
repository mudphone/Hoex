defmodule HoexTest do
  use ExUnit.Case

  defmodule Mathy do
    def no_op, do: :ok
    def div(a, b), do: a / b
    def div(a, b, c), do: a / b / c
    def div(a, b, c, d), do: a / b / c / d
    def div(a, b, c, d, e), do: a / b / c / d / e
    def add(a, b), do: a + b
    def mul(a, b), do: a * b
    def dbl(a), do: a * 2
  end

  test "arity calculation" do
    assert Hoex.arity(&AnyModule.any_name/4) == 4
    assert Hoex.arity(&AnyModule.any_name/1) == 1
    assert Hoex.arity(&AnyModule.any_name/0) == 0
  end

  test "curry of a arity 3 function" do
    f = Hoex.curry(&Mathy.div/3)
    f2 = f.(10)
    f3 = f2.(5)
    assert f.(10).(5).(2) == 1.0
    assert f2.(2).(1) == 5.0
    assert f3.(2) == 1.0
  end

  test "curry of a arity 0 function" do
    f = Hoex.curry(&Mathy.no_op/0)
    assert f.() == Mathy.no_op
  end

  test "compose 2 functions" do
    f = &Mathy.dbl/1
    g = &Mathy.add/2
    c = Hoex.comp(f, g)
    assert c.(10, 2) == 24.0
  end

  test "compose function w/ variable number of args" do
    f = &Mathy.dbl/1
    assert Hoex.comp(f, &Mathy.div/3).(10,5,2) == 2
    assert Hoex.comp(f, f).(2) == 8
  end

  test "composing 3 functions" do
    f = &Mathy.dbl/1
    assert Hoex.comp(f, f, f).(2) == 16
  end

  test "composing 4 functions" do
    f = &Mathy.dbl/1
    assert Hoex.comp(f,f,f,f).(2) == 32
  end

  test "composing 5 functions" do
    f = &Mathy.dbl/1
    assert Hoex.comp(f,f,f,f,f).(2) == 64
  end

  test "flipping a function's arguments" do
    f = Hoex.flip(&Mathy.div/2)
    assert f.(2, 10) == 5
  end

  test "partial application of function arguments" do
    assert Hoex.partial(&Mathy.div/2, 10).(5) == 2
    assert Hoex.partial(&Mathy.div/3, 10, 5).(2) == 1
    assert Hoex.partial(&Mathy.div/4, 10, 2, 2.5).(2) == 1
    assert Hoex.partial(&Mathy.div/5, 100, 2, 10, 2.5).(2) == 1
  end

  test "composing with pipes" do
    xs = [1,2,3]
    doubling = Hoex.curry(Hoex.flip(&Enum.map/2)).(&Mathy.dbl/1)
    assert Enum.map(xs, &Mathy.dbl/1) |> doubling.() == [4,8,12]
  end
end
