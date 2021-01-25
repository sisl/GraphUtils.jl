export
    AbstractTreeNode,
    get_parent,
    get_children,
    set_parent!,
    validate_tree

"""
    abstract type AbstractTreeNode{E,ID}

E is element type, ID is id type
"""
abstract type AbstractTreeNode{ID} end
_id_type(n::AbstractTreeNode{ID}) where {E,ID} = ID

mutable struct TreeNode{E,ID} <: AbstractTreeNode{ID}
    id::ID
    element::E
    parent::TreeNode{E,ID}
    children::Dict{ID,TreeNode{E,ID}}
    function TreeNode{E,ID}(e) where {E,ID}
        t = new{E,ID}()
        t.id = get_unique_id(ID)
        t.element = e
        t.parent = t
        t.children = Dict{ID,TreeNode{E,ID}}()
        return t
    end
end

node_id(node::AbstractTreeNode) = node.id
get_parent(n::AbstractTreeNode) = n.parent
get_children(n::AbstractTreeNode) = n.children
function set_parent!(child::AbstractTreeNode,parent::AbstractTreeNode)
    @assert !(child === parent)
    delete!(get_children(get_parent(child)), node_id(child))
    parent.children[child.id] = child
    child.parent = parent
end

"""
    get_root_node(n::AbstractTreeNode{E,ID}) where {E,ID}

Return the root node of a tree
"""
function get_root_node(n::AbstractTreeNode{ID}) where {ID}
    # identify the root of the tree
    ids = Set{ID}()
    node = n
    parent_id = nothing
    while !(parent_id === node_id(node))
        parent_id = node_id(node)
        if parent_id in ids
            throw(ErrorException("Tree is cyclic!"))
        end
        push!(ids,parent_id)
        node = get_parent(node)
    end
    return node
end

"""
    validate_tree(n::AbstractTreeNode)

Ensure that the subtree of n is in fact a tree--no cycles, and no duplicate ids
"""
function validate_sub_tree(n::N) where {ID,N<:AbstractTreeNode{ID}}
    # Breadth-first search
    node = n
    frontier = Dict{ID,N}(node_id(node)=>node)
    explored = Set{ID}()
    while !isempty(frontier)
        id,node = pop!(frontier)
        if node_id(node) in explored
            @warn "$node already explored--is there a cycle?"
            return false
        end
        push!(explored,node_id(node))
        for (child_id,child) in get_children(node)
            push!(frontier,child_id=>child)
        end
    end
    return true
end

"""
    validate_tree(n::AbstractTreeNode)

Ensure that the transform tree is in fact a tree--no cycles, and no duplicate
ids
"""
function validate_tree(n::AbstractTreeNode{ID}) where {ID}
    node = get_root_node(n)
    validate_sub_tree(node)
end