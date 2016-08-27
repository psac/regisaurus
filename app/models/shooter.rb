class Shooter < ActiveRecord::Base
  attr_accessible :age, :first_name, :gender, :last_name, :member, :waiver, :uspsa_number, :agc_number, :agc_member, :military, :law, :add_membership, :remove_membership, :club_board
  attr_accessor :add_membership, :remove_membership

  has_many :registrations

  validates :last_name, :first_name, :age, :gender, presence: true

  validates :agc_number, presence: true, if: :agc_member

  before_create :fix_names

  before_save :update_membership, :fix_uspsa

  scope :ordered, lambda { order('last_name ASC') }

  def update_membership
    self.member = Time.now.year if add_membership
    self.member = nil if remove_membership
  end

  def fix_names
    self.first_name = first_name.capitalize
    self.last_name = last_name.capitalize
  end

  def fix_uspsa
    self.uspsa_number = uspsa_number.to_s.upcase.gsub /[^\w\d]/, ''
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  def special
    cats = []
    cats << 'law' if law
    cats << 'mil' if military
    cats.join(' ')
  end

  def self.where_like(query)
    search_fields = %w{first_name last_name uspsa_number}
    search_fields.collect! do |f|
      "#{f} LIKE '#{query}%'"
    end
    where(search_fields.join(' OR '))
  end

  def self.ages
    %w{ADULT SENIOR SUPSNR JUNIOR}
  end

  def current_member?
    member == Time.now.year.to_s or club_board.present?
  end
  def current_waiver?
    return false if waiver.nil?
    (waiver + 1.year).to_time > Time.now
  end
end
