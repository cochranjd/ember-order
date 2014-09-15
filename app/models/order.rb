class Order < ActiveRecord::Base
  has_many :selections
  has_many :menuitems, :through => :selections

  before_create :set_token

  before_save :detect_status
  before_save :update_total

  after_create :send_email
  after_create :update_status

  after_update :check_for_status_change

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  CC_NUMBER_REGEX = /\A[0-9]{12,16}\Z/
  CC_EXPIRE_REGEX = /\A(0[1-9]|1[0-2])\/([0-9]{2})\Z/
  validates :email, presence: true, format: { with: EMAIL_REGEX }
  validates :cc_number, format: {with: CC_NUMBER_REGEX, allow_blank: true}
  validates :cc_expire, format: {with: CC_EXPIRE_REGEX, allow_blank: true}

private

  def set_token
    begin
      self.token = SecureRandom.hex 4
    end while self.class.exists?(token: token)

    true
  end

  def detect_status
    (self.status = 'COMPLETED' and self.is_paid = true and return true) if has_payment_info?
    (self.status = 'SELECTED' and return true) if !self.menuitems.empty?

    true
  end

  def has_payment_info?
    valid = true
    valid = valid && !self.cc_number.blank?
    valid = valid && !self.cc_expire.blank?
    valid = valid && !self.cc_name.blank?

    return valid
  end

  def update_total
    self.total_price_in_cents = self.menuitems.sum('price_in_cents')

    true
  end

  def send_email
    if self.status == 'INIT' && !self.is_master
      InvitedMailer.invited(self).deliver
    end

    true
  end

  def check_for_status_change
    update_status if self.status_changed?

    true
  end

  def update_status
    ActiveSupport::Notifications.instrument("orderStatusUpdate", :data => { :container_id => self.container_id, :email => self.email, :status => self.status })

    true
  end
end