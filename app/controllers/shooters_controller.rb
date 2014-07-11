class ShootersController < ApplicationController

  respond_to :json, only: :search
  before_filter :authenticate_user!, except: [:search, :create]

  def search
    @shooters = Shooter.where_like(params[:q])
    respond_with @shooters
  end

  # GET /shooters
  # GET /shooters.json
  def index
    @shooters = Shooter.ordered.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shooters }
    end
  end

  # GET /shooters/1
  # GET /shooters/1.json
  def show
    @shooter = Shooter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shooter }
    end
  end

  # GET /shooters/new
  # GET /shooters/new.json
  def new
    @shooter = Shooter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shooter }
    end
  end

  # GET /shooters/1/edit
  def edit
    @shooter = Shooter.find(params[:id])
  end

  # POST /shooters
  # POST /shooters.json
  def create
    @shooter = Shooter.new(params[:shooter])

    respond_to do |format|
      if @shooter.save
        format.html { redirect_to @shooter, notice: 'Shooter was successfully created.' }
        format.json { render json: @shooter, status: :created, location: @shooter }
      else
        format.html { render action: "new" }
        format.json { render json: @shooter.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shooters/1
  # PUT /shooters/1.json
  def update
    @shooter = Shooter.find(params[:id])

    respond_to do |format|
      if @shooter.update_attributes(params[:shooter])
        format.html { redirect_to @shooter, notice: 'Shooter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shooter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shooters/1
  # DELETE /shooters/1.json
  def destroy
    @shooter = Shooter.find(params[:id])
    @shooter.destroy

    respond_to do |format|
      format.html { redirect_to shooters_url }
      format.json { head :no_content }
    end
  end
end
