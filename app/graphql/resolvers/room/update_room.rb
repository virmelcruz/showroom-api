class Resolvers::Room::UpdateRoom < GraphQL::Function
    
  argument :id, !types.String
  argument :room_no, !types.String
  argument :floor, types.String
  argument :user, types.String

  type Types::RoomType

  def call(_obj, args, ctx)
    room = Room.find(args[:id])
    room_params = args.to_h
    
    if room
      if room.update_attributes(room_params)
        room
      else
        GraphQL::ExecutionError.new("Error on updating Room: #{room.errors.full_messages.join(", ")}")
      end
    end

  end
end