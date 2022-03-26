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