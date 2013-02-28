# coding: utf-8
class UsersController < ApplicationController
  #------#
  # show #
  #------#
  def show( id )
#    @user       = User.where( id: id ).first
    @user       = User.where( slug: id ).first
    @my_plans   = Plan.where( user_id: @user.id ).includes( :user ).order( "created_at DESC" )
    @plan_feeds = Feed.where( plan_id: @my_plans.pluck(:id) ).where( "user_id != ?", @user.id ).includes( :plan, :user ).order( "created_at DESC" ).all
    @my_feeds   = Feed.where( user_id: @user.id ).includes( :plan, :user ).order( "created_at DESC" ).all
    @entries    = Entry.where( user_id: @user.id ).includes( :user, :plan ).order( "created_at DESC" ).all
    @favorites  = Favorite.where( user_id: @user.id ).includes( :user, :plan ).order( "created_at DESC" ).all
    @cheers     = Cheer.where( user_id: @user.id ).includes( :user, :plan ).order( "created_at DESC" ).all
  end

  #------#
  # feed #
  #------#
  def feed
    session[:feed_reed_at] = Time.now
    @feeds = Feed.where( user_id: session[:user_id] ).includes( [:plan, {:entry => :user}, {:comment => [:user, :plan]}, :user] ).order( "created_at DESC" ).all
  end
end
