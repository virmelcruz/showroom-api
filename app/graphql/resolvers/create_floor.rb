class Resolvers::CreateFloor < GraphQL::Function

  argument :name, !types.String

  type Types::FloorType

  def call(_obj, args, ctx)
    floor = Floor.new(args.to_h)
    
    if floor.save
      floor
    end

  end
end