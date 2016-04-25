module IdeasHelper
  def user_like(i)
    @user_like = i.like_for(current_user)
  end

  def user_join(i)
    @user_join = i.join_for(current_user)
  end
end
