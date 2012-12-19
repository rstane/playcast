# coding: utf-8
class PlansController < ApplicationController
  #-------#
  # index #
  #-------#
  def index
    @plans = Plan.where( user_id: session[:user_id] ).all
  end

  #------#
  # show #
  #------#
  def show( id )
    @plan = Plan.where( id: id, user_id: session[:user_id] ).first

    @comment = Comment.new
    @comments = Comment.where( plan_id: @plan.id ).includes( :user ).order( "comments.created_at ASC" ).all
  end

  #-----#
  # new #
  #-----#
  def new
    @plan = Plan.new
  end

  #------#
  # edit #
  #------#
  def edit( id )
    @plan = Plan.where( id: id, user_id: session[:user_id] ).first
  end

  #--------#
  # create #
  #--------#
  def create( plan )
    @plan = Plan.new( plan )
    @plan.user_id = session[:user_id]

    if @plan.save
      redirect_to( plan_path( @plan ), notice: "プランを作成しました。" )
    else
      render action: "new"
    end
  end

  #--------#
  # update #
  #--------#
  def update( id, plan )
    @plan = Plan.where( id: id, user_id: session[:user_id] ).first

    if @plan.update_attributes( plan )
      redirect_to( plan_path( @plan ), notice: "プランを更新しました。" )
    else
      render action: "edit"
    end
  end

  #---------#
  # destroy #
  #---------#
  def destroy( id )
    plan = Plan.where( id: id, user_id: session[:user_id] ).first
    plan.destroy ? flash[:notice] = "Plan was successfully deleted." : flash[:alert] = "Plan was failed deleted."

    redirect_to plans_path
  end
end
