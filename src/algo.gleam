import gleam/io
import sort

pub fn main() {
  echo sort.select_sort([5, 6, 2, 12, 3, 8, 7])
  echo sort.select_sort([5, 3])
  echo sort.select_sort([])

  echo sort.quick_sort([5, 6, 2, 12, 3, 8, 7])
  echo sort.quick_sort([5, 3])
  echo sort.quick_sort([])

  echo sort.ss_sort([5, 6, 2, 12, 3, 8, 7])
  echo sort.ss_sort([5, 3])
  echo sort.ss_sort([])

  echo sort.merge_sort([5, 6, 2, 12, 3, 8, 7, 122, 0, 9, 4, 1])
}
