defmodule IsolationForestTest do
  alias Supervisor.Spec
  use ExUnit.Case
  doctest IsolationForest


  test "create_ranges" do
    mid = 3
    range = %{"s"=>1, "e"=>6}
    assert IsolationForest.create_ranges(mid, range) == 
    [%{"s"=>1, "e"=>3}, %{"s"=>3, "e"=>6}]
  end


  test "split_range" do
    assert IsolationForest.split_range(%{"s"=>1, "e"=>6}) == 
    [%{"s"=>1, "e"=>3.5}, %{"s"=>3.5, "e"=>6}]
  end

  test "split - ranges are split in two" do
    ranges = [%{"s"=>1, "e"=>6}, %{"s"=>6, "e"=>7}]
    
    assert IsolationForest.split(ranges, 0) == %{
    "l" => [%{"s"=>1, "e"=>3.5}, %{"s"=>6, "e"=>7}], 
    "r"=> [%{"s"=>3.5, "e"=>6}, %{"s"=>6, "e"=>7}]
    }
  end

  test "grep by range" do
    assert IsolationForest.grep_by_range([[1,2],[3,4],[5,6]],0,%{"s" => 0, "e" => 3.5}) ==
    %{true => [[1,2],[3,4]], false => [[5,6]]}
  end
  
end
