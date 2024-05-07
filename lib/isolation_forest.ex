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
    Enum.split_with(& range["e"] > Enum.at(&1, dim) and Enum.at(&1, dim) > range["s"])
    # then(fn groups -> Map.merge(%{true => [[0,0]], false => [[0,0]]}, groups) end)
  end


  #TODO: obcas se stane ze mame jen false vetev a nemame true a naopak
  def left_right data, dim, dim_count, ranges, depth \\ 0 do
    {left_range, right_range} = split(ranges, dim)
    # IO.inspect(dim, label: "dim")
    # IO.inspect({left_range, right_range}, label: "left right ranges")
    # IO.inspect(data, label: "before grep")
    # IO.inspect(grep_by_range(data, dim, Enum.at(right_range,dim)), label: "grep right")
    # IO.inspect(grep_by_range(data, dim, Enum.at(left_range,dim)), label: "grep left")
    
    {left_data, right_data} = grep_by_range(data, dim, Enum.at(right_range,dim))
    {
    %{"depth" => depth,"ranges" => left_range, "data" => left_data, "dim" => Enum.random(0..dim_count-1), "left" => %{}, "right" => %{}},
    %{"depth" => depth,"ranges" => right_range, "data" => right_data, "dim" => Enum.random(0..dim_count-1), "left" => %{}, "right" => %{}}
    }
  end
  
    
  def init_tree data, ranges, dim_count, max_depth \\ 5, depth \\ 0 do
    {left, right} = left_right(data,Enum.random(0..dim_count-1), dim_count, ranges, depth)
    IO.inspect({left, right},label: "lr" )
    IO.inspect(length(left["data"]))

    
    lr = case left do
      %{"data" => d} when length(d) <= 1 -> left
      %{"ranges" => [%{"s" => x, "e" => y}, _]} when x == y -> left
      _ -> %{left | "left" => init_tree(left["data"], left["ranges"], dim_count, max_depth - 1, depth + 1)}
    end 

  
    rr = case right do
      %{"data" => d} when length(d) <= 1 -> right
      %{"ranges" => [_, %{"s" => x, "e" => y}]}  when x == y -> right
      _ -> %{right | "right" => init_tree(right["data"], right["ranges"], dim_count, max_depth - 1, depth + 1)}
    end

    {lr, rr}
    
  end

end
