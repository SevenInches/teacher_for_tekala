class RoleUser
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :role_id, Integer

  belongs_to :role
end
