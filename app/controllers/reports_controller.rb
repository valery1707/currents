class ReportsController < ApplicationController
	before_action :set_report, only: [:show, :edit, :update, :destroy]
	# before_action :set_current_user_reports
	before_action :authenticate_user!
  skip_before_filter :authenticate_user!, :only => :locations_for_state


	# @reports = current_user.reports.order("date DESC")

	def index
		@reports = current_user.reports
		@filtered_reports = @reports.filter(params.slice(:species, :location, :state, :tide, :date)).page params[:page]
		@species_for_filter = @reports.select("DISTINCT(species_id)").unscope(:order)
		@tides_for_filter = @reports.collect(&:tide).uniq
		@state_for_filter = @reports.collect(&:state).uniq.sort_by{ |state| [state.visible ? 0 : 1, state.name] }
		@locations_for_filter = @reports.collect(&:location).uniq.sort_by { |location| location.short_name }
	end

	def show
		@reports = Report.all
	end

	# GET /reports/new
	def new
		@report = Report.new
		species
	end

	# GET /reports/1/edit
	def edit
    @report = Report.find(params[:id])
		species
	end

	# POST /reports
	# POST /reports.json
	def create
		@report = Report.new(report_params)
		@report.user=current_user
		respond_to do |format|
			if @report.save
				format.html { redirect_to reports_url, notice: 'Report was successfully created.' }
				# format.json { render :show, status: :created, location: @report }
			else
				format.html { render :new }
				format.json { render json: @report.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /reports/1
	# PATCH/PUT /reports/1.json
	def update
		respond_to do |format|
			if @report.update(report_params)
				format.html { redirect_to reports_url, notice: 'Report was successfully updated.' }
				format.json { render :show, status: :ok, location: @report }
			else
				format.html { render :edit }
				format.json { render json: @report.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /reports/1
	# DELETE /reports/1.json
	def destroy
		@report.destroy
		respond_to do |format|
			format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
			format.json { head :no_content }
		end
	end
	def locations_for_state
		@state = State.find(params[:state_short_code])
		@state_locations = @state.locations.order(:number)
	end



	private

	# current user should be setup in private
	# def set_current_user_reports
	# @reports = current_user.reports
	# @reports_for_filter = @reports.select("DISTINCT(target_species)") #sets up target_species for filter box
	# end


	# Use callbacks to share common setup or constraints between actions.
	def set_report
		@report = Report.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def report_params
		params.require(:report).permit(:date, :species_id, :state_waters, :general_location, :catch_keepers, :catch_total, :trip_summary, :primary_method, :tide, :weather, :wind, :spot, :picture, :best_bait, :trip_description, :location_id)
	end
	def location_params
		@location = Location.find_by(short_name: params[:short_name])
	end
	def filtering_params params
		params.slice(:species, :location, :tide, :date)
	end

	def species
		@species ||= Species.all
	end
end
