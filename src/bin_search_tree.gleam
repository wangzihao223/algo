import gleam/order

pub type TreeNode(val) {
  TreeNode(val: val, left: TreeNode(val), right: TreeNode(val))
  Null
}

pub type BinTree(val) {
  BinTree(root: TreeNode(val), val_compare: fn(val, val) -> order.Order)
}

pub fn search(tree: BinTree(a), val: a) {
  case tree.root {
    Null -> Null
    root -> search_1(root, val, tree.val_compare)
  }
}

pub fn del(tree: BinTree(a), val: a) {
  let root = tree.root
  case root {
    Null -> Null
    TreeNode(..) -> del_1(root, val, tree.val_compare)
  }
}

pub fn insert(tree: BinTree(a), val: a) {
  let root = tree.root
  case root {
    Null -> BinTree(..tree, root: TreeNode(val, Null, Null))
    TreeNode(..) -> BinTree(..tree, root: insert_1(root, val, tree.val_compare))
  }
}

fn search_1(node, val, val_compare) {
  case node {
    Null -> Null
    TreeNode(v1, left, right) -> {
      case val_compare(v1, val) {
        order.Eq -> node
        order.Gt -> search_1(right, val, val_compare)
        order.Lt -> search_1(left, val, val_compare)
      }
    }
  }
}

fn del_1(node, val, val_compare) {
  case search_1(node, val, val_compare) {
    Null -> Null
    TreeNode(left: left, right: Null, ..) -> left
    TreeNode(left: Null, right: right, ..) -> right
    TreeNode(right: right, left: left, ..) -> {
      let assert TreeNode(..) as new = find_min(right)
      TreeNode(..new, left: left, right: del_1(right, new.val, val_compare))
    }
  }
}

fn insert_1(node, val, val_compare) {
  case node {
    Null -> TreeNode(val, Null, Null)
    TreeNode(v, left, right) ->
      case val_compare(v, val) {
        order.Eq -> node
        order.Gt -> TreeNode(..node, right: insert_1(right, val, val_compare))
        order.Lt -> TreeNode(..node, left: insert_1(left, val, val_compare))
      }
  }
}

fn find_min(node) {
  case node {
    Null -> Null
    TreeNode(left: left, ..) -> {
      case left {
        Null -> node
        TreeNode(..) -> find_min(left)
      }
    }
  }
}
