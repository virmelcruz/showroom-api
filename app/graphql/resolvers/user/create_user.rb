class Resolvers::User::CreateUser < GraphQL::Function
    
  argument :name, !types.String
  argument :email, !types.String
  argument :password, types.String
  
  type Types::UserType

  def call(_obj, args, ctx)
    user = User.new(args.to_h)
    
    if user.save
      user
    else
      GraphQL::ExecutionError.new("Invalid input for User: #{user.errors.full_messages.join(", ")}")
    end

  end
end