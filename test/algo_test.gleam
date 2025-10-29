import gleam/list
import gleeunit
import heap
import myqueue
import priority_queue
import sort

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  let name = "Joe"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Joe!"
}

pub fn queue_test() {
  let q = myqueue.new()

  // in

  let q2 =
    [1, 2, 3, 4, 5]
    |> list.fold(q, fn(acc, x) { myqueue.insert(acc, x) })
  // echo q2
  // out 
  loop(q2)
}

pub fn heap_test() {
  let hp =
    heap.from_list(
      [5, 6, 2, 12, 3, 8, 7, 122, 0, 9, 4, 1],
      heap.max_heap_shift_up,
      heap.max_heap_shift_down,
    )
  // let hp2 =
  //   list.fold([5, 6, 2, 12, 3, 8, 7, 122, 0, 9, 4, 1], hp, fn(hp, x) {
  //     heap.binary_heap_push(hp, x)
  //   })
  loop_pop(hp)
}

pub fn heap_sort_test() {
  echo sort.heap_sort([5, 6, 2, 12, 3, 8, 7, 122, 0, 9, 4, 1])
}

pub fn priority_queue_test() {
  [#(4, "工作"), #(5, "睡觉"), #(3, "玩手机"), #(6, "吃饭")]
  |> list.fold([], fn(acc, x) {
    let #(k, v) = x
    [priority_queue.QueueElement(k, v), ..acc]
  })
  |> priority_queue.new
  |> pq_loop_pop
}

fn pq_loop_pop(pq) {
  case priority_queue.pop(pq) {
    priority_queue.Empty -> Nil
    priority_queue.PopResult(data, pq1) -> {
      echo data
      pq_loop_pop(pq1)
    }
  }
}

fn loop_pop(hp) {
  case heap.binary_heap_pop(hp) {
    heap.Empty -> Nil
    heap.PopResult(data, hp2) -> {
      echo data
      loop_pop(hp2)
    }
  }
}

fn loop(q) {
  case myqueue.pop(q) {
    myqueue.Empty -> Nil
    myqueue.DequeueResult(v, q) -> {
      // echo v
      loop(q)
    }
  }
}
