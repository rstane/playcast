# coding: utf-8
class UsersController < ApplicationController

  #------#
  # show #
  #------#
  def show( id )
    @user = User.where( id: id ).first
    @plans = Plan.where( user_id: @user.id ).includes( :user ).order( "created_at DESC" ).all
    @entries = Entry.where( user_id: @user.id ).includes( :user, :plan ).order( "created_at DESC" ).all
    @favorites = Favorite.where( user_id: @user.id ).includes( :user, :plan ).order( "created_at DESC" ).all
  end
end
