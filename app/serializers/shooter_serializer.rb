class ShooterSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :uspsa_number, :gender, :age, :member, :agc_number
end
