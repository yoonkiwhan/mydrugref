class FriendshipController < ApplicationController

def create
  @trustee = User.find(params[:id])
  @current_user.friends << @trustee
  redirect_to user_url
  flash[:notice] = "Trustee added."
end

def destroy
  @trustee = User.find(params[:id])
  @current_user.friends.delete(@trustee)
  redirect_to user_url
  flash[:notice] = "Trustee removed."  
end


end
