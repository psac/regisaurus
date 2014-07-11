class RegistrationSerializer < ActiveModel::Serializer
  attributes :id, :shooter_id, :match_id, :fee, :paid, :notes, :division, :power_factor, :squad
end
