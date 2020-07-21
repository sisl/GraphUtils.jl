# module Arrays

export
    pad_matrix

"""
    helper to pad a matrix with some value around the edges
"""
function pad_matrix(mat::Matrix{T}, pad_size::Tuple{Int,Int},pad_val::T) where T
    new_size = [size(mat)...] + 2*[pad_size...]
    A = fill!(typeof(mat)(undef,new_size[1],new_size[2]),pad_val)
    A[
        pad_size[1]+1:pad_size[1]+size(mat,1),
        pad_size[2]+1:pad_size[2]+size(mat,2)
    ] .= mat
    A
end

# end
