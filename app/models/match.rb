class Match < ActiveRecord::Base

  attr_accessible :created_at, :title, :club, :club_id, :active, :import_csv

  attr_accessor :import_csv

  after_save :process_csv

  def process_csv
    if import_csv.present?
      require 'csv'
      transaction do
        CSV.foreach import_csv.tempfile, headers: true do |row|
          shooter = Shooter.find_by_uspsa_number row['memberID']
          unless shooter
            age = 'ADULT'
            gender = 'MALE'
            specials = row['special'].to_s.split(',').map(&:strip)

            gender = 'FEMALE' if specials.include? 'Lady'
            age = 'JUNIOR' if specials.include? 'Junior'
            age = 'SENIOR' if specials.include? 'Senior'
            age = 'SUPSNR' if specials.include? 'Super Senior'

            s = shooter = Shooter.create(
              first_name: row['first name'],
              last_name: row['last name'],
              uspsa_number: row['memberID'],
              gender: gender,
              age: age,
            )

            if s.errors.any?
              raise s.errors.full_messages.join ', '
            end

          end

          if ['Production', 'PCC', 'Carry Optics'].include? row['division']
            row['power factor'] = 'Minor'
          end

          r = registrations.create(
            shooter: shooter,
            division: row['division'],
            power_factor: row['power factor'],
            squad: row['squad'],
          )

          if r.errors.any?
            raise r.errors.full_messages.join ', '
          end
        end
      end
    end
  end

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
