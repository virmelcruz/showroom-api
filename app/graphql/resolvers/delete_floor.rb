class Resolvers::DeleteFloor < GraphQL::Function
    
  argument :id, !types.String

  type Types::FloorType

  def call(_obj, args, ctx)
    floor = Floor.find(args[:id])
    
    if floor
      if floor.destroy
        floor
      else
        GraphQL::ExecutionError.new("Error on deleting Floor: #{floor.errors.full_messages.join(", ")}")
      end
    end
  end
end