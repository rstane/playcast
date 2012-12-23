# coding: utf-8
class PlansController < ApplicationController
  #-------#
  # index #
  #-------#
  def index
    @plans = Plan.includes( :user ).all
    @favorites = Favorite.where( plan_id: @plans.map{ |a| a.id }, user_id: session[:user_id] ).index_by{ |x| x.plan_id }
  end

  #------#
  # show #
  #------#
  def show( id )
    @plan    = Plan.where( id: id ).first
    @entries = Entry.where( plan_id: @plan.id ).includes( :user ).order( "created_at DESC" ).all

    @comment  = Comment.new
    @comments = Comment.where( plan_id: @plan.id ).includes( :user ).order( "comments.created_at ASC" ).all

    @favorite = Favorite.where( user_id: session[:user_id], plan_id: @plan.id ).first
    @entry    = Entry.where( user_id: session[:user_id], plan_id: @plan.id ).first
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
