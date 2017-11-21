class Resolvers::Room::CreateRoom < GraphQL::Function
    
  argument :room_no, !types.String
  argument :floor, !types.String
  argument :user, types.String
  
  type Types::RoomType

  def call(_obj, args, ctx)
    room = Room.new(args.to_h)
    
    if room.save
      room
    else
      GraphQL::ExecutionError.new("Invalid input for Room: #{room.errors.full_messages.join(", ")}")
    end

  end
end