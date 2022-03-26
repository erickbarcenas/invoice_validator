defmodule InvoiceValidatorTest do
  use ExUnit.Case
  doctest InvoiceValidator

  test "greets the world" do
    assert InvoiceValidator.hello() == :world
  end
end
