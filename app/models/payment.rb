class Payment < ActiveRecord::Base
  belongs_to :order

  before_save :set_paid_flag
  after_save :set_parent_status

  CC_NUMBER_REGEX = /\A[0-9]{12,16}\Z/
  CC_EXPIRE_REGEX = /\A(0[1-9]|1[0-2])\/([0-9]{2})\Z/
  validates :cc_number, format: {with: CC_NUMBER_REGEX, allow_blank: true}
  validates :cc_expire, format: {with: CC_EXPIRE_REGEX, allow_blank: true}

  private

  def set_paid_flag
    valid = true
    valid = valid && !self.cc_number.blank?
    valid = valid && !self.cc_expire.blank?
    valid = valid && !self.cc_name.blank?

    self.is_paid = valid

    true
  end

  def set_parent_status
    self.order.update_attribute(:status, 'COMPLETED') if self.is_paid

    true
  end

end
