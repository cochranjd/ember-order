class Api::MenuitemsController < ApplicationController
    respond_to :json

    def index
        @menuitems = Menuitem.all
        respond_with @menuitems, status: :ok and return
    end

    def show
        @menuitem = Menuitem.find(params[:id])
        head :not_found and return if @menuitem.nil?

        respond_with @menuitem, status: :ok and return
    end
end
