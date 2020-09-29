let
    @test sprint_padded(4;pad=5)                == "    4"
    @test sprint_padded("hi";pad=5)             == "   hi"
    @test sprint_padded("hi";
        pad=5,leftaligned=true)                 == "hi   "
    @test sprint_padded_list([1,10,2];pad=3)    == "[  1 10  2]"
    @test sprint_padded_list([1,10,2];
        pad=3,leftaligned=true)                 == "[1  10 2  ]"
    @test sprint_padded_list_array([[1,2,3],[4,5,6]];
        id_pad=3,pad=3,leftaligned=true)        ==  """
                                                      1: [1  2  3  ]
                                                      2: [4  5  6  ]
                                                    """
    @test sprint_indexed_list_array([[1,2,3],[4,5,6]];
        id_pad=4,pad=3,leftaligned=true) ==  "   T:  0  1  2   \n   1: [1  2  3  ]\n   2: [4  5  6  ]\n"
end
