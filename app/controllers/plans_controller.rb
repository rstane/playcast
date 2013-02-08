# coding: utf-8
class PlansController < ApplicationController
  #-------#
  # index #
  #-------#
  def index( category_id, sort, keyword )
    @plans = Plan.scoped

    # ----- 抽出条件 ----- #
    if category_id.present?
      plan_ids = Categorize.where( category_id: category_id ).pluck(:plan_id)
      @plans   = @plans.where( id: plan_ids )
    end

    if keyword.present?
      @plans   = @plans.where( "title LIKE ?", "%#{keyword}%" )
    end

    @plans = @plans.includes( :user, { :categorizes => :category } )

    # ----- ソート順 ----- #
    if sort.present? and sort == "populur"
      @plans = @plans.order( "plans.cheers_count DESC, plans.favorites_count DESC" )
    else
      @plans = @plans.order( "plans.created_at DESC" )
    end

    @plans = @plans.all

    @favorites  = Favorite.where( plan_id: @plans.map{ |a| a.id }, user_id: session[:user_id] ).index_by{ |x| x.plan_id }
  end

  #------#
  # show #
  #------#
  def show( id )
    @plan       = Plan.where( id: id ).first
    @entries    = Entry.where( plan_id: @plan.id ).includes( :user ).order( "created_at DESC" ).all
    @cheers     = Cheer.where( plan_id: @plan.id ).includes( :user ).order( "created_at DESC" ).all
    @categorize = Categorize.where( plan_id: @plan.id ).includes( :category ).order( "categories.name ASC" ).all

    schedules = Schedule.where( plan_id: @plan.id ).order( "candidate_day ASC" )
    @entry_schedules  = schedules.pluck(:id)
    @schedules        = schedules.index_by{ |x| x.id }

    @participations   = Participation.where( plan_id: @plan.id ).includes( :user ).all

    @comment  = Comment.new
    @comments = Comment.where( plan_id: @plan.id ).includes( :user ).order( "comments.created_at ASC" ).all

    @favorite = Favorite.where( user_id: session[:user_id], plan_id: @plan.id ).first
    @cheer    = Cheer.where( user_id: session[:user_id], plan_id: @plan.id ).first
    @entry    = Entry.where( user_id: session[:user_id], plan_id: @plan.id ).first
  end

  #-----#
  # new #
  #-----#
  def new
    @plan = Plan.new( min_people: 1, max_people: 1 )
  end

  #------#
  # edit #
  #------#
  def edit( id )
    @plan = Plan.where( id: id, user_id: session[:user_id] ).first
    @categorize = Categorize.where( plan_id: @plan.id ).pluck(:category_id)
    @schedules  = Schedule.where( plan_id: @plan.id ).order( "schedules.candidate_day ASC" ).includes( :participations => :user ).all
  end

  #--------#
  # create #
  #--------#
  def create( plan, categories, schedules )
    @plan = Plan.new( plan )
    @plan.user_id = session[:user_id]

    if @plan.save
      # カテゴリ選択
      if categories.present?
        categories.each_pair{ |key, value|
          Categorize.where( plan_id: @plan.id, category_id: value ).first_or_create
        }
      end

      # 候補日作成
      if schedules.present?
        schedules.each_pair{ |key, value|
          new_schedule = Schedule.new
          new_schedule.number        = key
          new_schedule.plan_id       = @plan.id
          new_schedule.candidate_day = (value['date'].present? ? Time.parse( "#{value['date']} #{value['time(4i)']}:#{value['time(5i)']}" ) : nil)
          new_schedule.save
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
  def update( id, plan, categories, schedules )
    @plan = Plan.where( id: id, user_id: session[:user_id] ).first

    if @plan.update_attributes( plan )
      # カテゴリ更新
      Categorize.where( plan_id: @plan.id ).delete_all
      if categories.present?

        categories.each_pair{ |key, value|
          Categorize.where( plan_id: @plan.id, category_id: value ).first_or_create
        }
      end

      # 候補日更新(参加登録が無ければ)
      if schedules.present?
        schedules.each_pair{ |key, value|
          # 参加者が居なければ
          unless Participation.where( plan_id: @plan.id, schedule_id: key ).exists?
            schedule = Schedule.where( id: key, plan_id: @plan.id ).first
            schedule.candidate_day = (value['date'].present? ? Time.parse( "#{value['date']} #{value['time(4i)']}:#{value['time(5i)']}" ) : nil)
            schedule.save!
          else
            flash[:alert] = "既に参加者の居る候補日は変更出来ません。"
          end
        }
      end

      # 定員／最少開催人数チェック
      Plan.max_min_people_check( @plan.id )

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

  #----------#
  # favorite #
  #----------#
  def favorite( id, klass )
    plan = Plan.where( id: id ).first
    favorite = Favorite.where( user_id: session[:user_id], plan_id: id ).first_or_initialize

    # 登録／解除
    if favorite.id.present?
      favorite.destroy
      favorite = nil
    else
      favorite.save
    end

    render partial: 'favorite', locals: { favorite: favorite, plan: plan, klass: klass }
  end
end
