class InvoicesController < ApplicationController
  def update
    @invoice = Invoice.find params[:id]
    cols = %w(cash check points discounts)
    type = params[:type]
    result = false
    if cols.include? type
      amount = @invoice.send type
      amount += params[:amount].to_i
      @invoice.send type+'=', amount
      result = @invoice.save
    end
    render json: @invoice, root: false
  end
  def reset_payments
    @invoice = Invoice.find params[:id]
    @invoice.update_attributes cash: 0, points: 0, check: 0, discounts: 0
    render json: @invoice, root: false
  end
end
