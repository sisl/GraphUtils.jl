export
	AbstractRobotType,
	DeliveryBot,
	DefaultRobotType

abstract type AbstractRobotType end
struct DeliveryBot <: AbstractRobotType end
const DefaultRobotType = DeliveryBot

export
    AbstractID,
    ObjectID,
    BotID,
    RobotID,
    LocationID,
    ActionID,
    OperationID,
	AgentID,
	VtxID

abstract type AbstractID end
@with_kw struct ObjectID <: AbstractID
	id::Int = -1
end
@with_kw struct BotID{R<:AbstractRobotType} <: AbstractID
	id::Int = -1
end
const RobotID = BotID{DeliveryBot}
@with_kw struct LocationID <: AbstractID
	id::Int = -1
end
@with_kw struct ActionID <: AbstractID
	id::Int = -1
end
@with_kw struct OperationID <: AbstractID
	id::Int = -1
end
"""
	AgentID
Special helper for identifying agents.
"""
@with_kw struct AgentID <: AbstractID
	id::Int = -1
end
"""
	VtxID
Special helper for identifying schedule vertices.
"""
@with_kw struct VtxID <: AbstractID
	id::Int = -1
end

export
    reset_task_id_counter!,
    get_unique_task_id,
    reset_operation_id_counter!,
    get_unique_operation_id,
    reset_action_id_counter!,
    get_unique_action_id

TASK_ID_COUNTER = 0
get_unique_task_id() = Int(global TASK_ID_COUNTER += 1)
function reset_task_id_counter!()
    global TASK_ID_COUNTER = 0
end
OPERATION_ID_COUNTER = 0
get_unique_operation_id() = OperationID(Int(global OPERATION_ID_COUNTER += 1))
function reset_operation_id_counter!()
    global OPERATION_ID_COUNTER = 0
end
ACTION_ID_COUNTER = 0
get_unique_action_id() = ActionID(Int(global ACTION_ID_COUNTER += 1))
function reset_action_id_counter!()
    global ACTION_ID_COUNTER = 0
end

export
	get_id

get_id(id::AbstractID) = id.id
get_id(id::Int) = id
Base.:+(id::A,i::Int) where {A<:AbstractID} = A(get_id(id)+i)
Base.:+(id::A,i::A) where {A<:AbstractID} = A(get_id(id)+get_id(i))
Base.:-(id::A,i::Int) where {A<:AbstractID} = A(get_id(id)-i)
Base.:-(id::A,i::A) where {A<:AbstractID} = A(get_id(id)-get_id(i))
Base.:(<)(id1::AbstractID,id2::AbstractID) = get_id(id1) < get_id(id2)
Base.:(>)(id1::AbstractID,id2::AbstractID) = get_id(id1) > get_id(id2)
Base.isless(id1::AbstractID,id2::AbstractID) = id1 < id2
Base.convert(::Type{ID},i::Int) where {ID<:AbstractID} = ID(i)
