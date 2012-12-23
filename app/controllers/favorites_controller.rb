# coding: utf-8
class FavoritesController < ApplicationController
  #--------#
  # create #
  #--------#
  def create( plan_id )
    Favorite.create( user_id: session[:user_id], plan_id: plan_id )

    redirect_to( plan_path( plan_id ), notice: "お気に入りに登録しました。" )
  end

  #---------#
  # destroy #
  #---------#
  def destroy( plan_id, id )
    favorite = Favorite.where( user_id: session[:user_id], plan_id: plan_id, id: id ).first
    favorite.destroy

    redirect_to( plan_path( plan_id ), notice: "お気に入りを解除しました。" )
  end
end
