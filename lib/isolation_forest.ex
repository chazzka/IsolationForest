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


  #TODO: obcas se stane ze mame jen false vetev a nemame true a naopak
  def left_right data, dim, dim_count, ranges do
    {left_range, right_range} = split(ranges, dim)
    IO.inspect(dim, label: "dim")
    IO.inspect({left_range, right_range}, label: "new ranges")
    IO.inspect(grep_by_range(data, dim, Enum.at(right_range,dim)), label: "grep")
    %{true: left_data, false: right_data} = grep_by_range(data, dim, Enum.at(right_range,dim))
    {
    %{"ranges" => left_range, "data" => left_data, "dim" => Enum.random(0..dim_count-1), "left" => %{}, "right" => %{}},
    %{"ranges" => right_range, "data" => right_data, "dim" => Enum.random(0..dim_count-1), "left" => %{}, "right" => %{}}
    }
  end
  
    
  def init_tree data, ranges, dim_count do
    {left, right} = left_right(data,Enum.random(0..dim_count-1), dim_count, ranges)
    IO.inspect({left, right},label: "lr" )
    lr = case left do
      %{"data" => d} when length(d) == 1 -> left
      _ -> %{left | "left" =>init_tree(left["data"], left["ranges"], dim_count)}
    end 

  
    rr = case right do
      %{"data" => d} when length(d) == 1 -> right
      _ -> %{right | "right" => init_tree(right["data"], right["ranges"], dim_count)}
    end

    {lr, rr}
    
  end

end
