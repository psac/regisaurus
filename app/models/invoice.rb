class Invoice < ActiveRecord::Base
  attr_accessible :cash, :check, :points, :discounts

  has_many :registrations, dependent: :destroy
  belongs_to :match

  scope :paid, where(paid: true)

  before_save :update_paid

  def update_paid
    self.paid = (fee > 0 and amount_due == 0) ? true : 0 # this is a stupid stupid hack because the model wont save with false
  end

  def fee
    registrations.any? ? registrations.select(:fee).map(&:fee).reduce(:+) : 0
  end
  def amount_paid
    cash + check + points + discounts
  end
  def amount_due
    fee - amount_paid
  end
  def modified
    updated_at.to_i
  end
  def shooters
    registrations.map(&:shooter_name).join ', '
  end
  def adjusted_fee
    fee - discounts
  end


  def as_json(options)
    options.reverse_merge! methods: [:fee, :amount_due, :amount_paid, :registrations, :modified, :shooters]
    super options
  end
end
