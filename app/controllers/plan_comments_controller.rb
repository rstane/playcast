# coding: utf-8
class PlanCommentsController < ApplicationController
  #--------#
  # create #
  #--------#
  def create( plan_id, comment )
    com = PlanComment.new( comment )
    com.user_id = session[:user_id]
    com.plan_id = plan_id

    if com.save!
      flash[:notice] = "コメントを投稿しました。"
    else
      flash[:alert] = "コメントを投稿出来ませんでした。"
    end

    redirect_to( plan_path( plan_id ) )
  end

  #---------#
  # destroy #
  #---------#
  def destroy( id, plan_id )
    comment = PlanComment.where( id: id, user_id: session[:user_id] ).first
    comment.destroy

    redirect_to( plan_path( plan_id ) )
  end
end
