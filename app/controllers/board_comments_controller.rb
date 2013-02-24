# coding: utf-8
class BoardCommentsController < ApplicationController
  #--------#
  # create #
  #--------#
  def create( plan_id, board_comment )
    com = BoardComment.new( board_comment )
    com.user_id  = session[:user_id]
    com.plan_id  = plan_id

    if com.save!
      flash[:notice] = "コメントを投稿しました。"
    else
      flash[:alert] = "コメントを投稿出来ませんでした。"
    end

    redirect_to( plan_board_path( plan_id ) )
  end

  #---------#
  # destroy #
  #---------#
  def destroy( plan_id, id )
    comment = BoardComment.where( id: id, user_id: session[:user_id] ).first
    comment.destroy

    redirect_to( plan_board_path( plan_id ) )
  end
end
