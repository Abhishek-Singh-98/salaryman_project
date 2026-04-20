class CountriesController < ApplicationController
  before_action :authenticate_user

  def index
    @countries = Country.all
    render json: @countries, status: :ok
  end
end
