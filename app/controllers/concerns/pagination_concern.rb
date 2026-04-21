module PaginationConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_pagination_params, only: [:index]
  end

  private
  
  def set_pagination_params
    @page = params[:page] || 1
    @per_page = params[:per_page] || 25
  end

  def paginate(collection)
    collection.page(@page).per(@per_page)
  end

  def pagination_metadata(collection)
    {
      current_page: collection.current_page,
      per_page: collection.limit_value,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      next_page: collection.next_page,
      prev_page: collection.prev_page
    }
  end
end 