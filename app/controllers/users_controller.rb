# coding: utf-8
class UsersController < ApplicationController

  #------#
  # show #
  #------#
  def show( id )
    @user = User.where( id: id ).first
    @favorites = Favorite.where( user_id: @user.id ).includes( :user, :plan ).order( "created_at DESC" ).all
  end
end
