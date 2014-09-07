class InvoicesController < ApplicationController
  def update
    @invoice = Invoice.find params[:id]
    if @invoice.update_attributes invoice_params
      render json: @invoice, methods: [:registrations, :fee]
    else
      render :unprocessable_entity
    end
  end
  def show
    @invoice = Invoice.find params[:id]
    render json: @invoice, methods: [:registrations, :fee]
  end
  def reset_payments
    @invoice = Invoice.find params[:id]
    @invoice.update_attributes cash: 0, points: 0, check: 0, discounts: 0
    render json: @invoice, root: false
  end

  private

  def invoice_params
    params[:invoice].keep_if do |key, val|
      %w{cash check discounts points}.include? key
    end
  end
end
