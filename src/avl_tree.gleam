import gleam/int

pub type TreeNode(k, item) {
  TreeNode(
    val: k,
    items: List(item),
    height: Int,
    left: TreeNode(k, item),
    right: TreeNode(k, item),
  )
  Null
}

pub type AVLTree(k, item) {
  AVLTree(root: TreeNode(k, item))
}

pub fn new() {
  AVLTree(Null)
}

fn hight(node: TreeNode(k, item)) -> Int {
  case node {
    Null -> -1
    TreeNode(..) -> node.height
  }
}

fn update_height(node: TreeNode(k, item)) -> TreeNode(k, item) {
  case node {
    Null -> Null
    TreeNode(left: left, right: right, ..) -> {
      let h = int.max(hight(left), hight(right)) + 1
      TreeNode(..node, height: h)
    }
  }
}

fn blance_factor(node: TreeNode(k, item)) -> Int {
  case node {
    Null -> 0
    TreeNode(left: left, right: right, ..) ->
      // 节点平衡因子 = 左子树高度 - 右子树高度
      hight(left) - hight(right)
  }
}

fn right_rotate(node: TreeNode(k, item)) -> TreeNode(k, item) {
  case node {
    Null -> Null
    TreeNode(left: child, ..) -> {
      case child {
        Null -> Null
        TreeNode(right: grand_child, ..) -> {
          // 更新节点高度  
          let new_node = TreeNode(..node, left: grand_child) |> update_height
          TreeNode(..child, right: new_node) |> update_height
        }
      }
    }
  }
}

fn left_rotate(node: TreeNode(k, item)) -> TreeNode(k, item) {
  case node {
    Null -> Null
    TreeNode(right: child, ..) -> {
      case child {
        Null -> Null
        TreeNode(left: grand_child, ..) -> {
          let new_node = TreeNode(..node, right: grand_child) |> update_height
          TreeNode(..child, left: new_node) |> update_height
        }
      }
    }
  }
}

fn rotate(node: TreeNode(k, item)) -> TreeNode(k, item) {
  case node {
    Null -> Null
    TreeNode(..) ->
      case blance_factor(node) {
        // 左偏树
        bf if bf > 1 -> {
          case blance_factor(node.left) {
            bf1 if bf1 >= 0 -> right_rotate(node.left)
            _bf1 ->
              TreeNode(..node, left: left_rotate(node.left))
              |> right_rotate
          }
        }
        // 右偏树
        bf if bf < -1 -> {
          case blance_factor(node.right) {
            bf1 if bf1 <= 0 -> left_rotate(node)
            _bf1 ->
              // 先右旋后左旋
              TreeNode(..node, right: right_rotate(node.right))
              |> left_rotate
          }
        }
        //平衡树
        _bf -> node
      }
  }
}

pub fn insert(tree: AVLTree(k, item)) {
  todo
}

fn insert_1(node: TreeNode(k, item), val: k, item: item) {
  todo
}
