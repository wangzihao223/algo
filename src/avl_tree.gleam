import gleam/int
import gleam/order.{type Order}

// avl 树

pub type TreeNode(a) {
  TreeNode(val: a, hight: Int, left: TreeNode(a), right: TreeNode(a))
  Null
}

pub type AVLTree(a) {
  AVLTree(root: TreeNode(a), compare: fn(a, a) -> Order, add_eq: fn(a, a) -> a)
}

pub fn new(compare, add_eq) {
  AVLTree(Null, compare, add_eq)
}

pub fn insert(tree: AVLTree(a), v: a) {
  let new_root = insert_2(tree.root, v, tree.compare, tree.add_eq)
  AVLTree(..tree, root: new_root)
}

pub fn remove(tree: AVLTree(a)) {
  todo
}

fn insert_2(node: TreeNode(a), v: a, compare, add_eq) {
  case node {
    Null -> TreeNode(v, 0, Null, Null)
    TreeNode(v1, _h, l, r) -> {
      case compare(v1, v) {
        order.Eq -> {
          let new_v = add_eq(v1, v)
          TreeNode(..node, val: new_v)
        }
        // 左树
        order.Gt ->
          TreeNode(..node, left: insert_2(l, v, compare, add_eq))
          |> update_heigh
          |> rotate

        order.Lt ->
          TreeNode(..node, right: insert_2(r, v, compare, add_eq))
          |> update_heigh
          |> rotate
      }
    }
  }
}

// fn remove_2(node: TreeNode(a), v: a, compare, del_eq) {
//   case node {
//     Null -> Null
//     TreeNode(v1, _h, l, r) -> {
//       case compare(v1, v) {
//         order.Eq -> {
//           case del_eq(v1, v) {
//             Null -> {
//               case l, r {
//                 // 子节点数量为零直接删除
//                 Null, Null -> Null
//                 Null, r -> r
//                 l, Null -> l
//                 // 子节点 == 2
//                 l, r -> {
//                   todo
//                 }
//               }
//             }
//           }
//         }
//       }
//     }
//   }
// }

fn find_min_node(node: TreeNode(a), last) {
  case node {
    Null -> Null
    TreeNode(_v, _h, Null, r) -> {
      case last {
        Null -> r
        TreeNode(v1, h1, _l1, r1) -> TreeNode(v1, h1, Null, r1)
      }
    }
    TreeNode(v, h, l, r) -> {
      TreeNode(v, h, find_min_node(l, node), r)
    }
  }
}

pub fn int_compare(a: Int, with b: Int) -> Order {
  case a == b {
    True -> order.Eq
    False ->
      case a < b {
        True -> order.Lt
        False -> order.Gt
      }
  }
}

fn height(node: TreeNode(a)) {
  case node {
    Null -> 0
    TreeNode(_, h, _, _) -> h
  }
}

// 更新高度
fn update_heigh(node: TreeNode(a)) {
  case node {
    Null -> Null
    TreeNode(_v, _h, l, r) -> {
      //高度 = max(左子树高度，右子树高度)
      let max = int.max(height(l), height(r)) + 1
      TreeNode(..node, hight: max)
    }
  }
}

// 平衡因子
fn balance_factor(node: TreeNode(a)) {
  case node {
    Null -> 0
    TreeNode(_, _h, l, r) -> {
      // 节点平衡因子 = 左子树高度 - 右子树高度
      height(l) - height(r)
    }
  }
}

fn rotate(node: TreeNode(a)) {
  case balance_factor(node) {
    // 左偏
    x if x > 1 -> {
      let assert TreeNode(_, _, child_l, _) = node
      case balance_factor(child_l) >= 0 {
        // 右旋
        True -> right_rotate(node)
        False -> left_rotate(node) |> right_rotate
      }
    }
    // 右偏
    x if x < -1 -> {
      let assert TreeNode(_, _, _, child_r) = node
      case balance_factor(child_r) <= 0 {
        // 左旋
        True -> left_rotate(node)
        False -> right_rotate(node) |> left_rotate
      }
    }
    // 正常
    _x -> node
  }
}

// 右旋
fn right_rotate(node: TreeNode(a)) {
  case node {
    Null -> Null
    TreeNode(_, _h, child, _r) -> {
      case child {
        Null -> node
        TreeNode(_, _child_h, _child_l, grand_child) -> {
          let node1 = TreeNode(..node, left: grand_child)
          TreeNode(..child, right: node1)
        }
      }
    }
  }
}

// 左旋
fn left_rotate(node: TreeNode(a)) {
  case node {
    Null -> Null
    TreeNode(_, h, _h, child_r) -> {
      case child_r {
        Null -> node
        TreeNode(_, _h, grand_child_l, _r) -> {
          let node1 = TreeNode(..node, right: grand_child_l)
          TreeNode(..child_r, left: node1)
        }
      }
    }
  }
}
