class Api::OrdersController < ApplicationController
  respond_to :json

  def create
    @order = Order.new()
    @order.email = create_order_params[:email]
    @order.container_id = SecureRandom.hex
    @order.is_master = true
    @order.status = 'INIT'

    unless @order.save
      head :internal_server_error and return
    end

    create_order_params[:invitees].split( ',' ).map(&:strip).each do |email|
      invitee = Order.new
      invitee.email = email
      invitee.status = 'INIT'
      invitee.is_master = false
      invitee.container_id = @order.container_id
      invitee.save!
    end

    @order.status = 'OPEN'
    @order.save!

    respond_with @order, status: :created and return
  end

  def update
    @order = Order.find_by_token(params[:token])
    head :not_found and return if @order.nil?

    # Check for status update - only allow if moving from INIT to OPEN or 'DECLINED'
    if (['OPEN','DECLINED'].include?(update_order_params[:status]) && @order.status == 'INIT' )
      @order.status = update_order_params[:status]
    end

    # Check for menu items
    if update_order_params.has_key?(:menuitems)
      menuitems = Menuitem.find(update_order_params[:menuitems])
      @order.menuitems << menuitems
    end

    # Check for payment items
    if [:cc_number, :cc_expire, :cc_name].all? {|s| update_order_params.key? s}
      @order.cc_number = update_order_params[:cc_number]
      @order.cc_expire = update_order_params[:cc_expire]
      @order.cc_name = update_order_params[:cc_name]
    end

    @order.save!
    respond_with @order, status: :ok and return
  end

  def show
    @order = Order.find_by_token(params[:token])
    head :not_found and return if @order.nil?

    respond_with @order, status: :ok and return
  end

  def info
    order = Order.find_by_token(params[:token])
    @orders = Order.select("email","token", "status").where("container_id = ? AND token != ?", order.container_id, order.token )
    respond_with @orders, status: :ok and return
  end

private

  def create_order_params
    params.require(:order).permit(:email, :invitees)
  end

  # def invite_order_params
  #   params.require(:order).permit(:invitees)
  # end

  def update_order_params
    params.require(:order).permit(:status, :cc_number, :cc_expire, :cc_name, {:menuitems => []})
  end
end