class InvitedMailer < ActionMailer::Base
  default from: "from@example.com"

  def invited(order)
      @order = order
      mail(to: @order.email, subject: 'Place Your Order!!!')
  end
end
