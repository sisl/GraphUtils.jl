export
   sprint_padded,
   sprint_padded_list,
   sprint_padded_list_array


"""
   sprint_padded(i,pad=3,leftaligned=false)

Pads the string representation of i
"""
function sprint_padded(i,pad=3,leftaligned=false)
   padsym = leftaligned ? "-" : ""
   s = "%$(padsym)$(pad).$(pad)s"
   str = "$i"
   eval(quote
       @sprintf($s,$str)
   end)
end

"""
   sprint_padded_list(vec,pad=3,leftaligned=false)

Returns a string as in:
   ```
   julia> sprint_padded_list([1,2,3],3)
   "[  1  2  3]"
   ```
"""
function sprint_padded_list(vec,pad=3,leftaligned=false)
   string("[",map(x->sprint_padded(x,pad,leftaligned),vec)...,"]")
end

function sprint_padded_list_array(vecs,pad=3,leftaligned=false,id_pad=3)
   string([string(
         sprint_padded(i,id_pad),
         ": ",
         sprint_padded_list(vec,pad,leftaligned),
         "\n"
      ) for (i,vec) in enumerate(vecs)]...)
end
