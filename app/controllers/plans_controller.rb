# coding: utf-8
class PlansController < ApplicationController
  #-------#
  # index #
  #-------#
  def index( category_id )
    @plans = Plan.scoped
    if category_id.present?
      plan_ids = Categorize.where( category_id: category_id ).pluck(:plan_id)
      @plans   = @plans.where( id: plan_ids )
    end
    @plans = @plans.includes( :user, { :categorizes => :category } ).all

    @favorites = Favorite.where( plan_id: @plans.map{ |a| a.id }, user_id: session[:user_id] ).index_by{ |x| x.plan_id }
    @categories = Category.order( "name ASC" ).all
  end

  #------#
  # show #
  #------#
  def show( id )
    @plan       = Plan.where( id: id ).first
    @entries    = Entry.where( plan_id: @plan.id ).includes( :user ).order( "created_at DESC" ).all
    @categorize = Categorize.where( plan_id: @plan.id ).includes( :category ).order( "categories.name ASC" ).all

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
    @categories = Category.order( "name ASC" ).all
  end

  #------#
  # edit #
  #------#
  def edit( id )
    @plan = Plan.where( id: id, user_id: session[:user_id] ).first
    @categories = Category.order( "name ASC" ).all
    @categorize = Categorize.where( plan_id: @plan.id ).pluck(:category_id)
  end

  #--------#
  # create #
  #--------#
  def create( plan, categories )
    @plan = Plan.new( plan )
    @plan.user_id = session[:user_id]

    if @plan.save
      if categories.present?
        categories.each_pair{ |key, value|
          Categorize.where( plan_id: @plan.id, category_id: value ).first_or_create
        }
      end

      redirect_to( plan_path( @plan ), notice: "プランを作成しました。" )
    else
      render action: "new"
    end
  end

  #--------#
  # update #
  #--------#
  def update( id, plan, categories )
    @plan = Plan.where( id: id, user_id: session[:user_id] ).first

    if @plan.update_attributes( plan )
      Categorize.where( plan_id: @plan.id ).delete_all
      if categories.present?
        categories.each_pair{ |key, value|
          Categorize.where( plan_id: @plan.id, category_id: value ).first_or_create
        }
      end

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
