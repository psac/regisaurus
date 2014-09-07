class RegistrationsController < ApplicationController

  before_filter :authenticate_user!, except: [:index, :new, :create, :show]

  def waiver
    @registration = Registration.find(params[:id])
    @shooter = @registration.shooter
    @shooter.waiver = Time.now
    @shooter.save
    render json: @registration.invoice.registrations.as_json
  end

  # GET /registrations
  # GET /registrations.json

  def index
    @registrations = Match.active.get_registrations_by_squad

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @registrations, methods: :shooter_name }
    end
  end

  def manage
    @registrations = Match.active.registrations.new_first
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
    @registration = Registration.find(params[:id])
    @invoice = @registration.invoice

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @registration }
    end
  end

  # GET /registrations/new
  # GET /registrations/new.json
  def new
    @registration = Registration.new params[:registration]
    @registration.shooter = Shooter.new agc_member: false unless @registration.shooter_id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @registration }
    end
  end

  # GET /registrations/1/edit
  def edit
    @registration = Registration.find(params[:id])
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @registration = Match.active.registrations.new(params[:registration])

    respond_to do |format|
      if @registration.save
        format.html { redirect_to @registration, notice: 'Registration was successfully created.' }
        format.json { render json: @registration, status: :created, location: @registration }
      else
        format.html { render action: "new" }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /registrations/1
  # PUT /registrations/1.json
  def update
    @registration = Registration.find(params[:id])

    respond_to do |format|
      if @registration.update_attributes(params[:registration])
        format.html { redirect_to latest_matches_path, notice: 'Registration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    @registration = Registration.find(params[:id])
    @registration.destroy

    respond_to do |format|
      format.html { redirect_to latest_matches_path }
      format.json { head :no_content }
    end
  end
end
