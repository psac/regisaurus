class Match < ActiveRecord::Base

  attr_accessible :created_at, :title, :club, :club_id, :active

  def self.active
    where(active: true).first
  end

  def self.recent
    where('created_at > ?', Time.now - 5.days)
  end

  scope :ordered, order('club ASC, created_at DESC')

  default_scope ordered

  has_many :registrations
  has_many :invoices

  def get_registrations_by_squad
    registrations.includes(:shooter).includes(:invoice).group_by do |r|
      "Squad #{r.squad}"
    end
  end

  def registrations_with_shooters_and_invoice
    registrations.includes(:shooter).includes(:invoice)
  end

  def has_shooter? shooter
    registrations.where(shooter_id: shooter).length > 0
  end

  def has_more_than_one_shooter? shooter
    registrations.where(shooter_id: shooter).length > 1
  end

  def activate
    Match.update_all active: false
    self.active = true
    self.save
  end

  def total(method)
    invoices.paid.inject(0) { |total, invoice| total += invoice.try(method) }
  end

  def agc_total
    total = 0
    registrations.each do |reg|
      if reg.shooter.agc_member
        total += 2
      else
        total += 8
      end
    end
    total
  end
end
