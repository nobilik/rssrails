# app/controllers/feeds_controller.rb
class FeedsController < ApplicationController
  before_action :set_feed, only: %i[show edit update destroy]

  # GET /feeds
  def index
    @feeds = Feed.all
  end

  # GET /feeds/1
  def show; end

  # GET /feeds/new
  def new
    @feed = Feed.new
    @feeds_with_errors = []
  end

  # GET /feeds/1/edit
  def edit; end

  # POST /feeds
  def create
    urls = feed_params[:urls].split(/[,;\s\n\t\r\f\v]+/).map(&:strip).reject(&:empty?)

    if urls.empty?
      handle_empty_urls
    else
      @feeds_with_errors = create_feeds_with_errors(urls)
      handle_create_result
    end
  end

  # PATCH/PUT /feeds/1
  def update
    if @feed.update(feed_params)
      redirect_to @feed, notice: 'Feed was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /feeds/1
  def destroy
    @feed.destroy!
    redirect_to feeds_url, notice: 'Feed was successfully destroyed.', status: :see_other
  end

  private

  def handle_empty_urls
    flash.now[:alert] = 'No URLs provided. Please enter at least one URL.'
    @feed = Feed.new
    @feeds_with_errors = []
    render :new, status: :unprocessable_entity
  end

  def handle_create_result
    if @feeds_with_errors.empty?
      redirect_to feeds_path, notice: 'Feeds were successfully created.'
    else
      @feed = Feed.new
      render :new, status: :unprocessable_entity
    end
  end

  def create_feeds_with_errors(urls)
    feeds_with_errors = []

    urls.each do |url|
      feed = Feed.new(url:)
      feeds_with_errors << feed unless feed.save
    end

    feeds_with_errors
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_feed
    @feed = Feed.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def feed_params
    params.require(:feed).permit(:urls, :url)
  end
end
