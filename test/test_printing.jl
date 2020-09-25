let
    @test sprint_padded(4,5)                    == "    4"
    @test sprint_padded("hi",5)                 == "   hi"
    @test sprint_padded("hi",5,true)            == "hi   "
    @test sprint_padded_list([1,10,2],3)        == "[  1 10  2]"
    @test sprint_padded_list([1,10,2],3,true)   == "[1  10 2  ]"
    @test sprint_padded_list_array(
        [[1,2,3],[4,5,6]],3,true,3)             ==  """
                                                      1: [1  2  3  ]
                                                      2: [4  5  6  ]
                                                    """
    @test sprint_indexed_list_array(
        [[1,2,3],[4,5,6]],3,true,3)             ==  """
                                                      T: [1  2  3  ]
                                                      1: [1  2  3  ]
                                                      2: [4  5  6  ]
                                                    """
end
