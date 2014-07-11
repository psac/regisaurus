class Match < ActiveRecord::Base

  attr_accessible :created_at, :title, :club, :club_id, :active

  def self.active
    where(active: true).first
  end

  scope :ordered, order('club ASC, created_at DESC')

  default_scope ordered

  has_many :registrations
  has_many :invoices

  def get_registrations_by_squad
    lists = { squad1: [], squad2: [], squad3: [], squad4: [] }
    registrations.includes(:shooter).each do |r|
      next unless r.squad.in? 1..4
      index = "squad#{r.squad}".to_sym
      lists[index] << r
    end
    lists
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
end
