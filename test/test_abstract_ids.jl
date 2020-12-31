let
    reset_action_id_counter!()
    reset_operation_id_counter!()
    reset_task_id_counter!()

    @test get_id(get_unique_task_id()) == 1
    @test get_unique_operation_id() == OperationID(1)
    @test get_unique_action_id() == ActionID(1)
end
let
    ObjectID()
    RobotID()
    LocationID()
    ActionID()
    OperationID()

    get_id(ObjectID())

    @test ObjectID(1) < ObjectID(2)
    @test ObjectID(2) > ObjectID(1)
    @test ObjectID(1) + 1 == ObjectID(2)
    @test ObjectID(1) == ObjectID(2) - 1
end
