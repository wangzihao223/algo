import gleam/int
import gleam/list
import iv

pub type BinHeap(a) {
  BinHeap(
    data: iv.Array(a),
    shift_up: fn(iv.Array(a), Int, Int) -> Bool,
    shift_down: fn(iv.Array(a), Int, Int, Int) -> ShiftDownResult,
  )
}

pub type ShiftDownResult {
  ShiftDownResult(index: Int, bool: Bool)
}

pub type PopResult(a) {
  PopResult(data: a, heap: BinHeap(a))
  Empty
}

/// new binary empty heap
pub fn new_binary_heap(shift_up, shift_down) {
  BinHeap(iv.new(), shift_up, shift_down)
}

pub fn from_list(list, is_shift_up, is_shift_down) {
  let array1 = iv.from_list(list)
  let heap = BinHeap(array1, is_shift_up, is_shift_down)
  let i = iv.length(array1) - 1
  let p = parent_index(i)
  list.range(p, 0)
  |> list.fold(array1, fn(array, x) { shift_down(array, x, heap.shift_down) })
  |> BinHeap(is_shift_up, is_shift_down)
}

pub fn binary_heap_push(heap: BinHeap(a), item) {
  let array = heap.data
  let array1 =
    iv.append(array, item)
    |> shift_up(iv.length(array), heap.shift_up)
  BinHeap(..heap, data: array1)
}

pub fn binary_heap_pop(heap: BinHeap(a)) {
  let array = heap.data
  case iv.length(array) {
    0 -> Empty
    1 -> {
      let assert Ok(data) = iv.get(array, 0)
      PopResult(data, BinHeap(..heap, data: iv.new()))
    }
    _len -> {
      let assert Ok(data) = iv.get(array, 0)
      let array1 =
        iv.drop_first(array, 1)
        |> shift_down(0, heap.shift_down)
      PopResult(data, BinHeap(..heap, data: array1))
    }
  }
}

pub fn shift_down(heap, i, is_shift_down) {
  let left = left_index(i)
  let right = right_index(i)
  case is_shift_down(heap, i, left, right) {
    ShiftDownResult(bool: True, index: ma) -> {
      swap(heap, ma, i)
      |> shift_down(ma, is_shift_down)
    }
    ShiftDownResult(bool: False, index: _) -> {
      heap
    }
  }
}

pub fn shift_up(heap, i, is_shift_up) {
  case parent_index(i) {
    p if p < 0 || i == p -> heap
    p -> {
      case is_shift_up(heap, i, p) {
        True -> {
          swap(heap, i, p)
          |> shift_up(p, is_shift_up)
        }
        False -> heap
      }
    }
  }
}

pub fn max_heap_shift_down(heap, i, l, r) {
  let length = iv.length(heap)
  let assert Ok(i_data) = iv.get(heap, i)
  let ma = case l < length {
    True -> {
      let assert Ok(l_data) = iv.get(heap, l)
      case l_data > i_data {
        True -> l
        False -> i
      }
    }
    False -> i
  }
  let assert Ok(ma_data) = iv.get(heap, ma)
  let ma2 = case r < length {
    True -> {
      let assert Ok(r_data) = iv.get(heap, r)
      case r_data > ma_data {
        True -> r
        False -> ma
      }
    }
    False -> ma
  }
  case ma2 == i {
    True -> ShiftDownResult(bool: False, index: -1)
    False -> ShiftDownResult(bool: True, index: ma2)
  }
}

pub fn max_heap_shift_up(heap, i, p) {
  let assert Ok(a) = iv.get(heap, i)
  let assert Ok(b) = iv.get(heap, p)
  a >= b
}

pub fn min_heap_shift_up(heap, i, p) {
  let assert Ok(a) = iv.get(heap, i)
  let assert Ok(b) = iv.get(heap, p)
  a <= b
}

fn swap(heap, i, p) {
  let assert Ok(a) = iv.get(heap, i)
  let assert Ok(b) = iv.get(heap, p)
  let assert Ok(heap2) = iv.set(heap, i, b)
  let assert Ok(heap3) = iv.set(heap2, p, a)
  heap3
}

fn left_index(index) {
  2 * index + 1
}

fn right_index(index) {
  2 * index + 2
}

fn parent_index(index) {
  let assert Ok(x) = int.divide(index - 1, 2)
  x
}
