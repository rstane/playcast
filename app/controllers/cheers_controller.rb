# coding: utf-8
class CheersController < ApplicationController
  #--------#
  # create #
  #--------#
  def create( plan_id )
    Cheer.where( user_id: session[:user_id], plan_id: plan_id ).first_or_create

    redirect_to( plan_path( plan_id ) )
  end

  #---------#
  # destroy #
  #---------#
  def destroy( plan_id, id )
    cheer = Cheer.where( user_id: session[:user_id], plan_id: plan_id, id: id ).first
    cheer.destroy

    redirect_to( plan_path( plan_id ) )
  end
end
