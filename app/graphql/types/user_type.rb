Types::UserType = GraphQL::ObjectType.define do
  name 'UserType'
  description 'Represents user in a system'

  field :id, !types.ID
  field :email, !types.String
  field :name, types.String
  field :firstName, types.String, property: :first_name
  field :lastName, types.String, property: :last_name
  field :fullName, types.String do
    resolve -> (user, args, ctx) {
      user.full_name
    }
  end
  field :rooms, types[Types::RoomType]
end