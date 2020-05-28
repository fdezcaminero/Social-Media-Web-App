# rubocop:disable Layout/LineLength
# rubocop:disable Style/GuardClause

class FriendshipsController < ApplicationController
  def new
    current_user.friendships.build
  end

  def create
    @user = User.find(params[:requester_id])
    @r_request = current_user.received_requests.find_by(requester: @user.id, requestee: current_user.id)
    @friendship = current_user.friendships.build(status: true, requester_id: params[:requester_id])
    if @friendship.save
      @r_request.destroy
      redirect_to user_path(@user), notice: "You are now friends with #{@user.name}"
    else
      redirect_to user_path(@user), notice: 'Error accepting request'
    end
  end

  def destroy
    friendship = Friendship.find_by(params[:friendship_id])
    if friendship
      friendship.destroy
      redirect_to users_path, notice: 'You removed a friend'
    end
  end
end

# rubocop:enable Layout/LineLength
# rubocop:enable Style/GuardClause
