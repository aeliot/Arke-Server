class ConnectsController < ApplicationController
  before_action :set_connect, only: [:show, :edit, :update, :destroy]

  # GET /connects
  # GET /connects.json
  def index
    @connects = Connect.all
  end

  # GET /connects/1
  # GET /connects/1.json
  def show
  end

  # GET /connects/new
  def new
    @connect = Connect.new
  end

  # GET /connects/1/edit
  def edit
  end

  # POST /connects
  # POST /connects.json
  def create
    @connect = Connect.new(connect_params)

    respond_to do |format|
      if @connect.save
        format.html { redirect_to @connect, notice: 'Connect was successfully created.' }
        format.json { render action: 'show', status: :created, location: @connect }
      else
        format.html { render action: 'new' }
        format.json { render json: @connect.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /connects/1
  # PATCH/PUT /connects/1.json
  def update
    respond_to do |format|
      if @connect.update(connect_params)
        format.html { redirect_to @connect, notice: 'Connect was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @connect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /connects/1
  # DELETE /connects/1.json
  def destroy
    @connect.destroy
    respond_to do |format|
      format.html { redirect_to connects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_connect
      @connect = Connect.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def connect_params
      params[:connect]
    end
end
