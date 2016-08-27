class MatchesController < ApplicationController

  before_filter :authenticate_user!, except: :csv

  # GET /matches
  # GET /matches.json
  def index
    @matches = Match.all
    @recent = Match.recent

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @matches }
    end
  end

  def csv
    require 'csv'
    if params[:id]
      match = Match.find params[:id]
    else
      match = Match.active
    end

    Registration.other_shooters = []

    data = CSV.generate do |csv|
      csv << ['uspsa', 'first name', 'last name', 'squad', 'age', 'gender', 'division', 'power factor', 'special']
      match.invoices.paid.each do |i|
        i.registrations.each do |reg|
          csv << reg.export_row
        end
      end
    end

    send_data data, type: 'text/csv', filename: "#{match.title}.csv"
  end

  def agc_sheet
    if params[:id]
      @match = Match.find params[:id]
    else
      @match = Match.active
    end
    @registrations = @match.registrations
    @pages = @registrations.each_slice(25)
    @match_total = @match.agc_total;
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
    @match = Match.includes(invoices: [{registrations: [:shooter]}]).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json do
        render json: @match.invoices, root: false
      end
    end
  end

  def money
    @match = Match.find(params[:id])

    respond_to do |format|
      format.html
      format.csv do
        require 'csv'
        data = CSV.generate do |csv|
          csv << %w{invoice\ id shooter member fee discounts adjusted\ fee cash check points}
          @match.invoices.paid.each_with_index do |i, invoice_index|
            csv << []
            i.registrations.each_with_index do |r, index|
              invoice_id = index == 0 ? i.id : ''
              current_member = r.shooter.current_member? ? 'Yes' : 'No'
              csv << [invoice_id, r.shooter_name, current_member, r.fee]
            end
            csv << ['', 'Total', '', i.fee, i.discounts, i.adjusted_fee, i.cash, i.check, i.points]
          end
          csv << [] << []
          csv << [
              'TOTALS',
              '',
              '',
              @match.total(:fee),
              @match.total(:discounts),
              @match.total(:adjusted_fee),
              @match.total(:cash),
              @match.total(:check),
              @match.total(:points),
          ]
        end
        send_data data, type: 'text/csv', filename: "#{@match.title.parameterize('-')}_money_report.csv"
      end
    end
  end

  def latest
    @match = Match.active
    render :show
  end

  def activate
    @match = Match.find params[:id]
    @match.activate
    redirect_to matches_path, notice: "#{@match.title} is now the active match"
  end

  # GET /matches/new
  # GET /matches/new.json
  def new
    @match = Match.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @match }
    end
  end

  # GET /matches/1/edit
  def edit
    @match = Match.find(params[:id])
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = Match.new(params[:match])

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render json: @match, status: :created, location: @match }
      else
        format.html { render action: "new" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /matches/1
  # PUT /matches/1.json
  def update
    @match = Match.find(params[:id])

    respond_to do |format|
      if @match.update_attributes(params[:match])
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to matches_url }
      format.json { head :no_content }
    end
  end
end
