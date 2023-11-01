class FeedsController < ApplicationController
  before_action :set_feed, only: %i[ show edit update destroy ]

  # GET /feeds
  def index
    @feeds = Feed.all
  end

  # GET /feeds/1
  def show
  end

  # GET /feeds/new
  def new
    @errors=[]
    @feed = Feed.new
  end

  # GET /feeds/1/edit
  def edit
  end

  # POST /feeds
  def create
    urls = feed_params[:urls].split(/[,;\s\n\t\r\f\v]+/).map(&:strip).reject(&:empty?) # Split on spaces and commas, ; \n", "\t", "\r", "\f" or"\v"
    @errors = []
    
    if urls.length == 0 
      @errors << "No urls provided"
    end

    urls.each do |url|
      if !valid_url? url 
         @errors << 'Invalid url: ' + url
         next
      end
      @feed = Feed.new(url: url)
        
      unless @feed.save
        @errors << @feed.errors.full_messages
      end
    end

 

    if @errors.empty?
      redirect_to feeds_path, notice: "Feeds were successfully created."
    else
      @feed = Feed.new
      render :new, status: :unprocessable_entity
    end

  end


  # PATCH/PUT /feeds/1
  def update
    if @feed.update(feed_params)
      redirect_to @feed, notice: "Feed was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /feeds/1
  def destroy
    @feed.destroy!
    redirect_to feeds_url, notice: "Feed was successfully destroyed.", status: :see_other
  end

  private
    def valid_url?(url)
      if url =~ URI::regexp
        return true
      end
      false
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
