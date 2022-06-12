class User
  attr_reader :id, :first_name

  def initialize(user_hash)
    @id = user_hash[:id]
    @first_name = user_hash[:first_name]
  end
end
