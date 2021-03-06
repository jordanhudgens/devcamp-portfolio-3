class PortfoliosController < ApplicationController
	layout 'portfolio'
	access all: [:show, :index, :angular], user: {except: [:destroy, :new, :create, :update, :edit]}, company_admin: :all
	
	def index
		@portfolio_items = Portfolio.all
	end

	def angular
		@angular_portfolio_items = Portfolio.angular
	end

	def new
		@portfolio_item = Portfolio.new
		3.times { @portfolio_item.technologies.build }
	end

	def create
		@portfolio_item = Portfolio.new(portfolio_params)

		respond_to do |format|
			if @portfolio_item.save
				format.html { redirect_to portfolios_path, notice: "Portfolio item was successfully created." }
			else
				format.html { render :new }
			end
		end
	end

	def show
		@portfolio_item = Portfolio.find(params[:id])
	end

	def edit
		@portfolio_item = Portfolio.find(params[:id])
	end

	def update
		@portfolio_item = Portfolio.find(params[:id])

		if @portfolio_item.update(portfolio_params)
			redirect_to portfolio_show_path(@portfolio_item)
		else
			render :edit
		end
	end

	def destroy
		@portfolio_item = Portfolio.find(params[:id])
		@portfolio_item.destroy
		redirect_to portfolios_path
	end

	private

	def portfolio_params
		params.require(:portfolio).permit(:title, 
																			:subtitle, 
																			:body, 
																			:main_image, 
																			:thumb_image,
																			technologies_attributes: [:name])
	end
end
