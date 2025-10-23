pub type QueueT(value) {
  QueueT(value: value, next: QueueT(value))
  Nil
}

pub type DequeueResult(a) {
  DequeueResult(value: a, queue: QueueT(a))
  Empty
}

pub fn new() -> QueueT(a) {
  Nil
}

pub fn insert(q: QueueT(value), v: value) -> QueueT(value) {
  case q {
    Nil -> QueueT(v, Nil)
    QueueT(value, next) -> QueueT(value, insert(next, v))
  }
}

pub fn pop(q: QueueT(a)) -> DequeueResult(a) {
  case q {
    Nil -> Empty
    QueueT(value, next) -> DequeueResult(value, next)
  }
}
