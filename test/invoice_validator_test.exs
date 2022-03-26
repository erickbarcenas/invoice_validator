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


  data = [
      {"72 hrs atrás",   "America/Mazatlan",	~N[2022-03-20 13:06:31],	{ :error, "Invoice was issued more than 72 hrs before received by the PAC"} },
      {"72 hrs atrás",   "America/Mazatlan",	~N[2022-03-20 14:06:31],    { :error, "Invoice was issued more than 72 hrs before received by the PAC"} },
      {"72 hrs atrás",   "Mexico/General",	~N[2022-03-20 15:06:31],	:ok },
      {"72 hrs atrás",   "America/Cancun",	~N[2022-03-20 16:06:31],	:ok },
      {"72 hrs atrás",   "America/Mazatlan",	~N[2022-03-20 13:06:35],	{:error, "Invoice was issued more than 72 hrs before received by the PAC"} },
      {"72 hrs atrás",   "America/Mazatlan",	~N[2022-03-20 14:06:35],	{:error, "Invoice was issued more than 72 hrs before received by the PAC"} },
      {"72 hrs atrás",   "Mexico/General",	~N[2022-03-20 15:06:35],	:ok },
      {"72 hrs atrás",   "America/Cancun",	~N[2022-03-20 16:06:35],	:ok },
      {"5 mins adelante", "America/Mazatlan",	~N[2022-03-23 13:11:35],	:ok },
      {"5 mins adelante", "America/Mazatlan",	~N[2022-03-23 14:11:35],	:ok },
      {"5 mins adelante", "Mexico/General",	~N[2022-03-23 15:11:35],	:ok },
      {"5 mins adelante", "America/Cancun",	~N[2022-03-23 16:11:35],	{:error, "Invoice is more than 5 mins ahead in time"} },
      {"5 mins adelante", "America/Mazatlan",	~N[2022-03-23 13:11:36],	:ok }, #
      {"5 mins adelante", "America/Mazatlan",	~N[2022-03-23 14:11:36],	:ok }, #
      {"5 mins adelante", "Mexico/General",	~N[2022-03-23 15:11:36],	{:error, "Invoice is more than 5 mins ahead in time"} },
      {"5 mins adelante", "America/Cancun",	~N[2022-03-23 16:11:36],	{:error, "Invoice is more than 5 mins ahead in time"} } #ok
  ]


  for {limit, timezone, datetime, response} <- data do
      @limit limit
      @timezone timezone
      @datetime datetime
      @response response
      test "#{@limit}, emisor in #{@timezone} at #{@datetime} returns" do
          pac_date = DateTime.from_naive!(~N[2022-03-23 15:06:35], "Mexico/General")
          emisor = create_datetime(@datetime, @timezone)

        assert @response == InvoiceValidator.validate_dates(emisor, pac_date)
      end
  end
  
  defp create_datetime(%NaiveDateTime{} = naive_dt, tzone) do
      DateTime.from_naive!(naive_dt, tzone)
  end

end
