export
    matches_keywords,
    get_files_matching

"""
    matches_keywords(p,keywords)

Check if any of the keywords occurs in p.
"""
function matches_keywords(p,keywords)
    if isempty(keywords)
        return true
    end
    for k in keywords
        if findfirst(k,p) != nothing
            return true
        end
    end
    return false
end

"""
    get_files_matching(base_path,ext,keywords=[])

Get all files in a directory that match the extension `ext`, and (optionally)
which contain any of `keywords`
"""
function get_files_matching(base_path,ext,keywords=[])
    paths = String[]
    for (root,dirs,files) in walkdir(base_path)
        for f in files
            if matches_keywords(f,keywords) && splitext(f)[end] == ext
                push!(paths,joinpath(root,f))
            end
        end
    end
    return paths
end
