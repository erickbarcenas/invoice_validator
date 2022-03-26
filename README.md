# InvoiceValidator

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `invoice_validator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:invoice_validator, "~> 0.1.0"}
  ]
end
```

## Respuestas de preguntas

### 3.1 Enviar código del método/funcion que valida las fechas de emisión/timbrado [Tarea1]

```elixir
defmodule InvoiceValidator do
  @moduledoc """
      Somos un PAC.
      Validar si una factura es válida o no.
  """
  
  def datetime_to_utc(date_time) do
      offset = date_time.utc_offset # / 3600 

      base = date_time |> DateTime.to_string() |> String.split(" ")
      date = base |> Enum.at(0)
      time = base |> Enum.at(1) |> String.split("-") |> Enum.at(0)
      str_date = date <> " " <> time

      NaiveDateTime.from_iso8601!(str_date) 
      |> NaiveDateTime.add(offset, :second) 
      |> DateTime.from_naive!("Etc/GMT")

  end
  
  # Recibe Datetime Naive
  # pac_date = DateTime.utc_now
  def validate_dates(%DateTime{} = emisor_date, %DateTime{} = pac_date) do
      Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase) 
      # pac_date genera al momento de llegar emisor_date
      hour = 60*60
      five_minutes = 5*60 / hour
      time_limit = 72 

      dt1 = datetime_to_utc(emisor_date)
      dt2 = datetime_to_utc(pac_date)

      # emisor date se normaliza a utf
      diff = DateTime.diff(dt2, dt1, :second) / hour

      cond do
          diff < -five_minutes -> { :error, "Invoice is more than 5 mins ahead in time" }
          diff < (time_limit + five_minutes) -> :ok # Hacer el timbrado
          # diff > (time_limit + 1) -> { :error, "Invoice was issued more than 72 hrs before received by the PAC" }
          true -> 
              { :error, "Invoice was issued more than 72 hrs before received by the PAC" }
      end
  end
end
```

### 3.2 Enviar el código de las pruebas unitarias que desarrollaron para 3.1 [Tarea2]


```elixir
defmodule InvoiceValidatorTest do
  use ExUnit.Case
  doctest InvoiceValidator
  
  # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)


  @tz_cdmx "Mexico/General"
  @pac_dt DateTime.from_naive!(~N[2022-10-24 10:10:10], @tz_cdmx)

  @tag :noroeste
  test "offset: UTC-8 (Baja California, Tijuana)" do
      # timbrado: centro
      pac_date = DateTime.from_naive!(~N[2022-10-24 10:10:10], "Mexico/General")
      # emisión: cualquier lugar
      emisor_date1 = DateTime.from_naive!(~N[2022-10-21 07:10:10], "Mexico/BajaNorte")
      emisor_date2 = DateTime.from_naive!(~N[2022-10-24 13:00:00], "Mexico/BajaNorte")
      emisor_date3 = DateTime.from_naive!(~N[2022-10-24 12:00:00], "Mexico/BajaNorte")

      assert {:error, "Invoice was issued more than 72 hrs before received by the PAC"} == InvoiceValidator.validate_dates(emisor_date1, pac_date)
      assert {:error, "Invoice is more than 5 mins ahead in time"} == InvoiceValidator.validate_dates(emisor_date2, pac_date)
      assert :ok == InvoiceValidator.validate_dates(emisor_date3, @pac_dt)
  end

  @tag :pacifico
  test "offset: UTC-7 (Baja California Sur, Chihuahua, Nayarit and Sinaloa)" do
      # timbrado: centro
      pac_date = DateTime.from_naive!(~N[2022-10-24 10:10:10], "Mexico/General")
      # emisión: cualquier lugar
      emisor_date1 = DateTime.from_naive!(~N[2022-10-21 08:10:10], "Mexico/BajaSur")
      emisor_date2 = DateTime.from_naive!(~N[2022-10-24 12:00:00], "Mexico/BajaSur")
      emisor_date3 = DateTime.from_naive!(~N[2022-10-24 10:55:00], "Mexico/BajaSur")
      assert {:error, "Invoice was issued more than 72 hrs before received by the PAC"} == InvoiceValidator.validate_dates(emisor_date1, pac_date)
      assert {:error, "Invoice is more than 5 mins ahead in time"} == InvoiceValidator.validate_dates(emisor_date2, pac_date)
      assert :ok == InvoiceValidator.validate_dates(emisor_date3, pac_date)
  end

  @tag :centro
  test "offset: UTC-6 (centro, All except Baja California, Baja California Sur, Chihuahua, Nayarit, Quintana Roo, Sinaloa and Sonora)" do
      # timbrado: centro
      pac_date = DateTime.from_naive!(~N[2022-10-24 10:10:10], "Mexico/General")
      # emisión: cualquier lugar
      emisor_date1 = DateTime.from_naive!(~N[2022-10-21 07:10:10], "Mexico/General")
      emisor_date2 = DateTime.from_naive!(~N[2022-10-24 12:05:10], "Mexico/General")
      emisor_date3 = DateTime.from_naive!(~N[2022-10-24 10:14:10], "Mexico/General")
      assert {:error, "Invoice was issued more than 72 hrs before received by the PAC"} == InvoiceValidator.validate_dates(emisor_date1, pac_date)
      assert {:error, "Invoice is more than 5 mins ahead in time"} == InvoiceValidator.validate_dates(emisor_date2, pac_date)
      assert :ok == InvoiceValidator.validate_dates(emisor_date3, pac_date)
  end

  
  @tag :sureste
  test "offset: UTC-5 (Quintana Roo)" do
      # timbrado: centro
      pac_date = DateTime.from_naive!(~N[2022-10-24 10:10:10], "Mexico/General")
      # emisión: cualquier lugar
      emisor_date1 = DateTime.from_naive!(~N[2022-10-21 07:10:10], "America/Cancun")
      emisor_date2 = DateTime.from_naive!(~N[2024-10-24 12:00:10], "America/Cancun")
      emisor_date3 = DateTime.from_naive!(~N[2022-10-23 12:14:10], "America/Cancun")
      assert {:error, "Invoice was issued more than 72 hrs before received by the PAC"} == InvoiceValidator.validate_dates(emisor_date1, pac_date)
      assert {:error, "Invoice is more than 5 mins ahead in time"} == InvoiceValidator.validate_dates(emisor_date2, pac_date)
      assert :ok == InvoiceValidator.validate_dates(emisor_date3, pac_date)
  end
end
```


### 3.3 Considerando el código de 3.1
Enviar la evidencia del resultado obtenido por su código (screenshot), identificando cada una como zonahoraria.limite.estatus. Considera los valores de la tabla, ejemplo para el caso del primer registro, tu evidencia debe llamarse “America/tijuana.72hrs.fail”


### Testing (ExUnit)

```
mix test --trace --seed 0 test/invoice_validator_test.exs 
```

![testing](https://github.com/erickbarcenas/invoice_validator/blob/main/assets/testing.png)


### 3.4 Considerando lo que hiciste en 3.1 (tarea1) y en 3.2 (tarea2)
calcula el número de caminos que tiene tu método/función (complejidad ciclomática). Solo necesito el número de caminos posibles.

![coveralls](https://github.com/erickbarcenas/invoice_validator/blob/main/assets/excoveralls.png)



### Calcula el % de cobertura de sentencias de tu código. Revisa el número de sentencias de tu código y revisa el número de sentencias cubiertas con sus pruebas unitarias.

**Pruebas de cobertura (excoveralls)**
```
env MIX_ENV=test mix coveralls
```
```
...................

Finished in 0.07 seconds (0.00s async, 0.07s sync)
20 tests, 0 failures

Randomized with seed 352057
----------------
COV    FILE                                        LINES RELEVANT   MISSED
100.0% lib/invoice_validator.ex                       44       17        0
[TOTAL] 100.0%
----------------
```


```
env MIX_ENV=test mix coveralls.html
```

```
xdg-open cover/excoveralls.html
```


## Some util Commands

*Install dependencies*
```elixir
mix deps.get
```

*Create project*
```
mix new invoice_validator
```
*Testing*
```
mix test
```
```
 mix test --trace test/invoice_validator_test.exs 
```
