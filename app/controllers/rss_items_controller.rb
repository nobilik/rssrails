# app/controllers/rss_items_controller.rb
class RssItemsController < ApplicationController
  before_action :set_rss_item, only: %i[show destroy]

  def index
    @rss_items = filter_and_paginate_rss_items
  end

  def show; end

  def destroy
    @rss_item.destroy!
    redirect_to rss_items_url, notice: 'Archive item was successfully destroyed.', status: :see_other
  end

  def reset_filters
    redirect_to rss_items_path
  end

  private

  def filter_and_paginate_rss_items
    rss_items = RssItem.order('publish_date DESC')
    rss_items = apply_source_filter(rss_items)
    rss_items = apply_title_filter(rss_items)
    rss_items = apply_publish_date_filter(rss_items)
    rss_items.paginate(page: params[:page], per_page: 25)
  end

  def apply_source_filter(rss_items)
    return rss_items unless params[:source].present?

    rss_items.where('source LIKE ?', "%#{params[:source]}%")
  end

  def apply_title_filter(rss_items)
    return rss_items unless params[:title].present?

    rss_items.where('title LIKE ?', "%#{params[:title]}%")
  end

  def apply_publish_date_filter(rss_items)
    return rss_items unless params[:publish_date].present?

    date = Date.parse(params[:publish_date])
    rss_items.where('publish_date >= ? AND publish_date < ?', date, date + 1.day)
    # @rss_items = @rss_items.where("publish_date >= date(?) AND publish_date < date(?, '+1 day')",
    #                           params[:publish_date], params[:publish_date])
  end

  def set_rss_item
    @rss_item = RssItem.find(params[:id])
  end
end
