class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.new
    timeline_posts
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      timeline_posts
      render :index, alert: 'Post was not created.'
    end
  end

  private

  def timeline_posts
    current_user_friends = [current_user.id]

    current_user.friendships.each do |f|
      current_user_friends << f.requester_id
    end

    current_user.accepted_requests.each do |f|
      current_user_friends << f.requestee_id
    end

    @timeline_posts ||= Post.where(user_id: current_user_friends).ordered_by_most_recent
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
