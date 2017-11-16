class Resolvers::UpdateFloor < GraphQL::Function

  argument :id, !types.String
  argument :name, !types.String

  type Types::FloorType

  def call(_obj, args, ctx)
    floor = Floor.find(args[:id])
    floor_params = args.to_h
    
    if floor
      if floor.update_attributes(floor_params)
        floor
      else
        GraphQL::ExecutionError.new("Error on updating Floor: #{floor.errors.full_messages.join(", ")}")
      end
    end

  end
end