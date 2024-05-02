defmodule IsolationForest do

  

  def create_ranges mid, range do
    [%{"s" => range["s"], "e" => mid},%{"s" => mid, "e" => range["e"]}]
  end

  def split_range range do
    (range["s"] + range["e"])/2 |> 
    create_ranges(range)
  end


  def init_node_map [first, second] do
    %{
     "l" => first, 
     "r" => second
    }
  end

  def split ranges, dim do
    dim |>
    then(fn dim -> {Enum.at(ranges,dim),dim} end) |>
    then(fn {range,dim} -> split_range(range) |>  Enum.map(&List.replace_at(ranges,dim,&1)) end) |>
    init_node_map
  end

  def grep_by_range data, dim, range do
    data |>
    Enum.group_by(& range["e"] > Enum.at(&1, dim) and Enum.at(&1, dim) > range["s"])
  end

  #TODO: zacnes range,data,dimenze, udelas hash left right
  # vezmes z leftu range, data ,dimenze a udelas left right, to same z rightu
  # koncis az je v hashi v datech jen jeden bod

end
