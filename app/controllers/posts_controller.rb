class PostsController < ApplicationController

  # GET /posts
  def index
    @posts = []
    redis = Redis.new
    cached_posts = redis.get('cached_posts')

    return @posts if cached_posts.blank?

    parsed_data = JSON.parse(cached_posts)
    
    @posts = parsed_data.sort_by! { |item| item['publish_date'] }.reverse! || [] #Post.getPosts()

    # Filter by source
    @posts = @posts.select { |post| post['source'].downcase.include?(params[:source].downcase) } if params[:source].present?

    # Filter by title
    @posts = @posts.select { |post| post['title'].downcase.include?(params[:title].downcase) } if params[:title].present?

    # Filter by publish_date
    @posts = @posts.select { |post| post['publish_date'].include?(params[:publish_date]) } if params[:publish_date].present?
  end

  def reset_filters
    redirect_to posts_path
  end


end
