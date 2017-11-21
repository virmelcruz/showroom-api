class Resolvers::Floor::CreateFloor < GraphQL::Function

  argument :name, !types.String

  type Types::FloorType

  def call(_obj, args, ctx)
    floor = Floor.new(args.to_h)
    
    if floor.save
      floor
    else
      GraphQL::ExecutionError.new("Invalid input for Floor: #{floor.errors.full_messages.join(", ")}")
    end

  end
end