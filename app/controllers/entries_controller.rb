# coding: utf-8
class EntriesController < ApplicationController
  #--------#
  # create #
  #--------#
  def create( plan_id )
    Entry.where( user_id: session[:user_id], plan_id: plan_id ).first_or_create

    redirect_to( plan_path( plan_id ), notice: "プランに参加しました。" )
  end

  #---------#
  # destroy #
  #---------#
  def destroy( plan_id, id )
    entry = Entry.where( user_id: session[:user_id], plan_id: plan_id, id: id ).first
    entry.destroy

    redirect_to( plan_path( plan_id ), notice: "参加をキャンセルしました。" )
  end
end
