Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  # TODO: Remove me
  field :testField, types.String do
    description "An example field added by the generator"
    resolve ->(obj, args, ctx) {
      "Hello World!"
    }
  end

  field :createFloor, function: Resolvers::CreateFloor.new
  field :updateFloor, function: Resolvers::UpdateFloor.new
  field :deleteFloor, function: Resolvers::DeleteFloor.new
end
