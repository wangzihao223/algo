import gleam/int
import gleam/list
import gleam/result

// 简单排序
pub fn select_sort(nums: List(Int)) -> List(Int) {
  select_loop(nums, []) |> list.reverse
}

fn select_loop(nums: List(Int), res: List(Int)) {
  case nums {
    [] -> res
    [n] -> [n, ..res]
    [min, ..nums1] -> {
      let #(next, min) =
        list.fold(nums1, #([], min), fn(acc, n) {
          let #(next, min) = acc
          case n < min {
            True -> #([min, ..next], n)
            False -> #([n, ..next], min)
          }
        })
      select_loop(next, [min, ..res])
    }
  }
}

// 选择排序

pub fn ss_sort(nums) {
  case nums {
    [] -> []
    _ -> {
      let assert Ok(min) = min(nums)
      [min, ..nums |> remove_x(min) |> ss_sort]
    }
  }
}

fn min(nums) {
  case nums {
    [] -> Error(Nil)
    [min, ..next] -> {
      list.fold(next, min, fn(min, n) {
        case min > n {
          True -> n
          False -> min
        }
      })
      |> Ok
    }
  }
}

fn remove_x(nums, x) {
  case nums {
    [] -> []
    [a, ..next] if a == x -> next
    [a, ..next] -> [a, ..remove_x(next, x)]
  }
}

// 快速排序
pub fn quick_sort(nums: List(Int)) {
  q_sort(nums, [])
}

fn q_sort(nums: List(Int), acc: List(Int)) -> List(Int) {
  case nums {
    [] -> acc
    [n] -> [n, ..acc]
    [pivot, ..next] -> {
      let smaller = list.filter(next, fn(x) { x <= pivot })
      let larger = list.filter(next, fn(x) { x > pivot })
      q_sort(smaller, [pivot, ..q_sort(larger, acc)])
    }
  }
}

// 归并排序

///1. 分割成对
///2. 进行组合
pub fn merge_sort(nums: List(Int)) {
  split(nums)
  |> pair
}

// 分割
fn split(nums: List(Int)) {
  case nums {
    [] -> [[]]
    [n] -> [[n]]
    [e1, e2, ..next] if e1 < e2 -> [[e1, e2], ..split(next)]
    [e1, e2, ..next] -> [[e2, e1], ..split(next)]
  }
}

// 组合
fn pair(p) {
  let assert [r] = pair_1(p, [])
  r
}

fn pair_1(pairs: List(List(Int)), pairs2: List(List(Int))) {
  case pairs, pairs2 {
    [], [] -> [[]]
    [], [res] -> [res]
    [], [_, _, ..] -> pair_1(pairs2, [])
    [a1], _ -> pair_1([a1, ..pairs2], [])
    [a1, a2, ..next_parirs], _ -> {
      let p2 = [merge(a1, a2), ..pairs2]
      pair_1(next_parirs, p2)
    }
  }
}

fn merge(l1, l2) {
  case l1, l2 {
    [], l2 -> l2
    l1, [] -> l1
    [a1, ..next_l1], [b1, ..next_l2] -> {
      case a1 < b1 {
        True -> [a1, ..merge(next_l1, l2)]
        False -> [b1, ..merge(l1, next_l2)]
      }
    }
  }
}
