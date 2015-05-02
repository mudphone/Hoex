defmodule HoexTest do
  use ExUnit.Case

  defmodule Mathy do
    def no_op, do: :ok
    def div(a, b, c), do: a / b / c
    def add(a, b), do: a + b
    def mul(a, b), do: a * b
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
    g = &Mathy.add/2
    f = &(&1 / 2)
    c = Hoex.comp(f, g)
    assert c.(10, 2) == 6.0
  end

end
