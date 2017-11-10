Types::FloorType = GraphQL::ObjectType.define do
  name 'FloorType'
  description 'Represents floor in a system'

  field :id, !types.ID
  field :name, !types.String
  field :rooms, types[Types::RoomType]
end