defmodule PollutionData do
  def importLinesFromCSV do
    list =
      File.read!("pollution.csv")
      |> String.split()
  end

  def parseOneLine(line) do
    [date, hour, longitude, latitude, value] = String.split(line, ",")
    date = date
      |> String.split("-")
      |> Enum.reverse
      |> Enum.map(fn(x) -> elem(Integer.parse(x), 0) end)
      |> :erlang.list_to_tuple
    hour = hour |> String.split(":")
      |> Enum.map(fn(x) -> elem(Integer.parse(x), 0) end)
      |> :erlang.list_to_tuple
      |> Tuple.append(0)

    longitude = elem(Float.parse(longitude), 0)
    latitude = elem(Float.parse(latitude), 0)
    value = elem(Integer.parse(value), 0)
    %{:datetime => {date, hour}, :location => {longitude, latitude}, :pollutionLevel => value}
  end

  def parseLines() do
    importLinesFromCSV() |> Enum.map(fn(x) -> parseOneLine(x) end)
  end

  def identifyStations do
    list = parseLines() |> Enum.uniq_by(fn(m) -> m.location end)
  end

  def addStations do
    :pollution_gen_server_sup.start()
    name = fn x -> "station_#{elem(x, 0)}_#{elem(x, 1)}" end
    st = identifyStations()
      |> Enum.map(fn(s) -> {name.(s.location), s.location} end)
      |> Enum.each(fn {n, c} -> :pollution_gen_server.addStation(n, c) end)
  end


  def test do
    time_parsing = (fn() -> parseLines() end) |> :timer.tc |> elem(0) |> Kernel./(1_000_000)
    IO.puts "time parsed #{time_parsing}"
    time_stations = (fn() -> addStations() end) |> :timer.tc |> elem(0) |> Kernel./(1_000_000)
    IO.puts "time adding stations #{time_stations}"
  end

end
