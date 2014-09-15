class Api::CheckoutController < ApplicationController
    respond_to :json

    def show
        order = Order.find_by_token(params[:token])
        head :not_found and return if order.nil?

        @payment = order.payment
        respond_with @payment, status: :ok and return
    end

    def create
        order = Order.find_by_token(params[:token])
        head :not_found and return if order.nil?

        @payment = order.payment
        @payment.update_attributes(update_payment_params)

        # This is where payment processing would happen

        respond_with @payment, status: :ok and return
    end

private

    def update_payment_params
        params.require(:payment).permit(:cc_number, :cc_expire, :cc_name)
    end
end
