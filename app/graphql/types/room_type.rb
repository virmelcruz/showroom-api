Types::RoomType = GraphQL::ObjectType.define do
    name 'RoomType'
    description 'Represents room'
  
    field :id, !types.ID
    field :room_no, !types.String
    field :user, Types::UserType
    field :floor, Types::FloorType
  end