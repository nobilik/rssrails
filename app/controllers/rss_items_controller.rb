class RssItemsController < ApplicationController
  before_action :set_rss_item, only: %i[ show destroy ]

  def index
    @rss_items=RssItem.all.order('publish_date DESC')

        # Filter by source
    @rss_items = @rss_items.where("source LIKE ?", "%" + params[:source] + "%") if params[:source].present?

    # Filter by title
    @rss_items = @rss_items.where("title LIKE ?", "%" + params[:title] + "%") if params[:title].present?

    # Filter by publish_date
    @rss_items = @rss_items.where("publish_date >= date(?) AND publish_date < date(?, '+1 day')", params[:publish_date], params[:publish_date]) if params[:publish_date].present?

    @rss_items = @rss_items.paginate(page: params[:page], per_page:25)
  end

  def show
  end

  def destroy
    @rss_item.destroy!
    redirect_to rss_items_url, notice: "Archive item was successfully destroyed.", status: :see_other
  end

  def reset_filters
    redirect_to rss_items_path
  end

  private

    def set_rss_item
      @rss_item = RssItem.find(params[:id])
    end

end
