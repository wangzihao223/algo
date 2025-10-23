import gleam/list
import gleeunit
import heap
import myqueue

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
