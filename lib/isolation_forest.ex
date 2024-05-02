defmodule IsolationForest do

  

  def create_ranges mid, range do
    [%{"s" => range["s"], "e" => mid},%{"s" => mid, "e" => range["e"]}]
  end

  def split_range range do
    (range["s"] + range["e"])/2 |> 
    create_ranges(range)
  end

  def split ranges, dim do
    dim |>
    then(fn dim -> {Enum.at(ranges,dim),dim} end) |>
    then(fn {range,dim} -> split_range(range) |>  Enum.map(&List.replace_at(ranges,dim,&1)) end) |>
    List.to_tuple
  end

  def grep_by_range data, dim, range do
    data |>
    Enum.group_by(& range["e"] > Enum.at(&1, dim) and Enum.at(&1, dim) > range["s"])
  end

  def left_right data, dim, dim_count, ranges do
    {left_range, right_range} = split(ranges, dim)
    %{true: left_data, false: right_data} = grep_by_range(data, dim, Enum.at(left_range,dim))
    {
    %{"range" => left_range, "data" => left_data, "dim" => Enum.random(0..dim_count-1)},
    %{"range" => right_range, "data" => right_data, "dim" => Enum.random(0..dim_count-1)}
    }
  end

end
