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
    
    assert IsolationForest.split(ranges, 0) == {
     [%{"s"=>1, "e"=>3.5}, %{"s"=>6, "e"=>7}], 
     [%{"s"=>3.5, "e"=>6}, %{"s"=>6, "e"=>7}]
    }
  end

  test "grep by range" do
    assert IsolationForest.grep_by_range([[1,2],[3,4],[5,6]],0,%{"s" => 0, "e" => 3.5}) ==
    %{true => [[1,2],[3,4]], false => [[5,6]]}
  end

  test "left_right" do
    :rand.seed(:exsss, {56,151,130})
    ranges = [%{"s"=>1, "e"=>6}, %{"s"=>6, "e"=>7}]
    assert IsolationForest.left_right([[1,2],[3,4],[5,6]],0,2,ranges) == {
     %{"data" => [[3, 4]], "dim" => 0, "range" => [%{"e" => 3.5, "s" => 1}, %{"e" => 7, "s" => 6}]},
     %{"data" => [[1, 2], [5, 6]], "dim" => 1, "range" => [%{"e" => 6, "s" => 3.5}, %{"e" => 7, "s" => 6}]}
    }
  end
  
end
