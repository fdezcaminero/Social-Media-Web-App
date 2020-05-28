module UsersHelper

  def no_current_user_btn(user)
    if user != current_user 
      request_btn(user)
    end 
  end

  def request_btn(user)
    sent_request = current_user.friend_requests.find_by(requester: current_user.id, requestee: user.id)
    received_request = current_user.received_requests.find_by(requester: user.id, requestee: current_user.id)

    friendship = current_user.friendships.find_by(requestee: current_user.id, requester: user.id)
    accepted_friendship = current_user.accepted_requests.find_by(requestee: user.id, requester: current_user.id)

    if sent_request
      link_to('Cancel Request', friend_request_path(id: sent_request.id), method: :delete, class: 'request_btn')
    elsif received_request
      links = [link_to('Accept Request', friendships_path(status: true, requestee_id: current_user.id, requester_id: user.id), method: :post, class: 'request_btn'), link_to('Reject Request', friend_request_path(id: received_request.id), method: :delete, class: 'sp request_btn')]

      content_tag(:span) do
        links.collect { |link| concat content_tag(:span, link) }
      end
    elsif friendship
      link_to('Remove Friend', friendship_path(id: friendship.id), method: :delete, class: 'request_btn')
    elsif accepted_friendship
      link_to('Remove Friend', friendship_path(id: accepted_friendship.id), method: :delete, class: 'request_btn')
    elsif sent_request.nil? && received_request.nil? && friendship.nil?
      link_to('Send Friend Request', friend_requests_path(requester_id: current_user.id, requestee_id: user.id), method: :post, class: 'request_btn')
    end
  end

end