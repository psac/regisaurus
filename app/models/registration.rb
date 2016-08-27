class Registration < ActiveRecord::Base
  cattr_accessor :other_shooters
  attr_accessor :nofee_join
  attr_accessible :division, :notes, :power_factor, :squad, :shooter_id, :shooter_attributes, :shooter, :invoice_id, :fee, :join_psac

  belongs_to :shooter
  belongs_to :match
  belongs_to :invoice

  validates :shooter, :division, :power_factor, :squad, presence: true

  accepts_nested_attributes_for :shooter

  before_create :update_shooter_member, :calculate_fee, :create_invoice
  before_save :force_update_shooter_member, if: Proc.new { join_psac and shooter.member != Time.now.year.to_s }
  before_save :calculate_fee, if: Proc.new { join_psac_changed? and not fee_changed?}
  after_save :update_invoice
  after_destroy :update_invoice

  scope :old_first, order('updated_at ASC')
  scope :new_first, order('updated_at DESC')

  default_scope old_first

  def division_short
    {'Open' => 'opn', 'Limited' => 'ltd', 'Limited 10' => 'l10', 'Production' => 'prd', 'Carry Optics' => 'cop', 'Single Stack' => 'ss', 'Revolver' => 'rvo'}[division]
  end

  def export_row
    # ['uspsa', 'first name', 'last name', 'squad', 'age', 'gender', 'division', 'power factor', 'special']
    last_name = shooter.last_name
    self.class.other_shooters << shooter.id
    reg_number = self.class.other_shooters.find_all {|i| i == shooter.id}.length
    if reg_number > 1
      last_name += " #{reg_number}"
    end
    [shooter.uspsa_number, shooter.first_name, last_name, squad, shooter.age, shooter.gender, division, power_factor, shooter.special]
  end

  def shooter_name
    "#{shooter.first_name} #{shooter.last_name}"
  end

  def shooter_waiver
    shooter.current_waiver?
  end

  def update_shooter_member
    if join_psac
      shooter.member= Time.now.year
      shooter.save
    end
  end

  def force_update_shooter_member
    shooter.member= join_psac ? Time.now.year : nil
    shooter.save
  end

  # figure out the cost of this registration
  def calculate_fee
    cost = (shooter.current_member? or join_psac) ? 15 : 20
    has_shooter = persisted? ? match.has_more_than_one_shooter?(shooter) : match.has_shooter?(shooter)
    if has_shooter
      cost = 3
      self.squad = 5
    end
    if join_psac
      cost += 30
    end
    self.fee = cost
  end

  # if no invoice exists, we need to create one
  def create_invoice
    self.invoice = match.invoices.create unless invoice
  end

  # once we destroy a registration, we need to update the paid flag on the invoice or delete it all together
  def update_invoice
    if invoice.registrations.any?
      invoice.update_paid
    else
      invoice.destroy
    end
  end

  def as_json(options = {})
    options.reverse_merge! methods: [:shooter_name, :shooter_waiver, :division_short]
    hash = super options
    hash[:shooter] = shooter
    hash[:invoice] = invoice
    hash
  end

  class << self
    def divisions
      %w{Limited Open Single\ Stack Production Carry\ Optics Limited\ 10 Revolver}
    end
    def power_factors
      %w{Major Minor}
    end
  end
end
