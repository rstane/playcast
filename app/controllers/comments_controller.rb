# coding: utf-8
class CommentsController < ApplicationController
  #--------#
  # create #
  #--------#
  def create( plan_id, comment_content )
    comment = Comment.new(
      user_id: session[:user_id],
      plan_id: plan_id,
      content: comment_content
    )

    if comment.save
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
    comment = Comment.where( id: id, user_id: session[:user_id] ).first
    comment.destroy

    redirect_to( plan_path( plan_id ) )
  end
end
