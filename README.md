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

## Commands
```elixir
mix deps.get
```

### Testing (ExUnit)

```
mix test --trace --seed 0 test/invoice_validator_test.exs 
```

```
InvoiceValidatorTest [test/invoice_validator_test.exs]
  * test offset: UTC-8 (Baja California, Tijuana) (0.2ms) [L#13]
  * test offset: UTC-7 (Baja California Sur, Chihuahua, Nayarit and Sinaloa) (0.2ms) [L#27]
  * test offset: UTC-6 (centro, All except Baja California, Baja California Sur, Chihuahua, Nayarit, Qui  * test offset: UTC-6 (centro, All except Baja California, Baja California Sur, Chihuahua, Nayarit, Quintana Roo, Sinaloa and Sonora) (0.2ms) [L#40]
  * test offset: UTC-5 (Quintana Roo) (0.2ms) [L#54]
  * test 72 hrs atrás, emisor in America/Mazatlan at 2022-03-20 13:06:31 returns (0.1ms) [L#92]
  * test 72 hrs atrás, emisor in America/Mazatlan at 2022-03-20 14:06:31 returns (0.09ms) [L#92]
  * test 72 hrs atrás, emisor in Mexico/General at 2022-03-20 15:06:31 returns (0.1ms) [L#92]
  * test 72 hrs atrás, emisor in America/Cancun at 2022-03-20 16:06:31 returns (0.1ms) [L#92]
  * test 72 hrs atrás, emisor in America/Mazatlan at 2022-03-20 13:06:35 returns (0.1ms) [L#92]
  * test 72 hrs atrás, emisor in America/Mazatlan at 2022-03-20 14:06:35 returns (0.09ms) [L#92]
  * test 72 hrs atrás, emisor in Mexico/General at 2022-03-20 15:06:35 returns (0.1ms) [L#92]
  * test 72 hrs atrás, emisor in America/Cancun at 2022-03-20 16:06:35 returns (0.06ms) [L#92]
  * test 5 mins adelante, emisor in America/Mazatlan at 2022-03-23 13:11:35 returns (0.07ms) [L#92]
  * test 5 mins adelante, emisor in America/Mazatlan at 2022-03-23 14:11:35 returns (0.07ms) [L#92]
  * test 5 mins adelante, emisor in Mexico/General at 2022-03-23 15:11:35 returns (0.08ms) [L#92]
  * test 5 mins adelante, emisor in America/Cancun at 2022-03-23 16:11:35 returns (0.06ms) [L#92]
  * test 5 mins adelante, emisor in America/Mazatlan at 2022-03-23 13:11:36 returns (0.08ms) [L#92]
  * test 5 mins adelante, emisor in America/Mazatlan at 2022-03-23 14:11:36 returns (0.07ms) [L#92]
  * test 5 mins adelante, emisor in Mexico/General at 2022-03-23 15:11:36 returns (0.1ms) [L#92]
  * test 5 mins adelante, emisor in America/Cancun at 2022-03-23 16:11:36 returns (0.06ms) [L#92]

Finished in 0.08 seconds (0.00s async, 0.08s sync)
20 tests, 0 failures
```


### Pruebas de cobertura (excoveralls)
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

![coveralls](https://github.com/erickbarcenas/invoice_validator/blob/main/assets/excoveralls.png)



```
env MIX_ENV=test mix coveralls.html
```

```
xdg-open cover/excoveralls.html
```

## Another Commands

### Create project
```
mix new invoice_validator
```
### Testing
```
mix test
```
```
 mix test --trace test/invoice_validator_test.exs 
```
