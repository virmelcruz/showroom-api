class Resolvers::Room::DeleteRoom < GraphQL::Function
    
  argument :id, !types.String

  type types.String

  def call(_obj, args, ctx)
    room = Room.find(args[:id])
    
    if room
      if room.destroy
        room.id
      else
        GraphQL::ExecutionError.new("Error on Deleting Room: #{room.errors.full_messages.join(", ")}")
      end
    end
  end
end