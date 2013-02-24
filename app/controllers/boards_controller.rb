# coding: utf-8
class BoardsController < ApplicationController
  #------#
  # show #
  #------#
  def show( plan_id )
    @plan  = Plan.where( id: plan_id ).first

    unless @plan.participant?( session[:user_id] )
      flash[:alert] = "参加者ではありません。"
      redirect_to plan_path( @plan ) and return
    end

    @board = Board.where( plan_id: plan_id ).includes( :board_comments => :user ).order( "comments.created_at DESC" ).first

    if @board.blank?
      flash[:alert] = "掲示板がありません。"
      redirect_to plans_path and return
    end

    @comments = @board.board_comments
    @board_comment = BoardComment.new
  end
end
