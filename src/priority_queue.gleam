import heap.{ShiftDownResult}
import iv

pub type QueueElement(v) {
  QueueElement(key: Int, value: v)
}

pub opaque type PriorityQueue(v) {
  PriorityQueue(data: heap.BinHeap(QueueElement(v)))
}

pub type PopResult(v) {
  Empty
  PopResult(data: QueueElement(v), queue: PriorityQueue(v))
}

pub fn new(list) {
  heap.from_list(list, is_shift_up, is_shift_down)
  |> PriorityQueue
}

pub fn push(pq: PriorityQueue(v), element) {
  heap.binary_heap_push(pq.data, element)
  |> PriorityQueue
}

pub fn push_from_kv(pq: PriorityQueue(v), kv: #(Int, v)) {
  let #(k, v) = kv
  push(pq, QueueElement(k, v))
}

pub fn pop(pq: PriorityQueue(v)) {
  case heap.binary_heap_pop(pq.data) {
    heap.Empty -> Empty
    heap.PopResult(data, newheap) -> {
      PopResult(data, PriorityQueue(newheap))
    }
  }
}

pub fn is_shift_up(heap, i, p) {
  let assert Ok(QueueElement(k1, _)) = iv.get(heap, i)
  let assert Ok(QueueElement(k2, _)) = iv.get(heap, p)
  int_compare_up(k1, k2)
}

pub fn int_compare_up(now, parent) {
  parent < now
}

pub fn is_shift_down(heap, i, l, r) {
  let length = iv.length(heap)
  let assert Ok(QueueElement(i_data, _)) = iv.get(heap, i)
  let ma = case l < length {
    True -> {
      let assert Ok(QueueElement(l_data, _)) = iv.get(heap, l)
      case l_data > i_data {
        True -> l
        False -> i
      }
    }
    False -> i
  }
  let assert Ok(QueueElement(ma_data, _)) = iv.get(heap, ma)
  let ma2 = case r < length {
    True -> {
      let assert Ok(QueueElement(r_data, _)) = iv.get(heap, r)
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
