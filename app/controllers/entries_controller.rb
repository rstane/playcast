# coding: utf-8
class EntriesController < ApplicationController
  #--------#
  # create #
  #--------#
  def create( plan_id, entry )
    plan = Plan.where( id: plan_id ).first

    if plan.blank? or plan.entry_close_flag == true or plan.gender_entry_close?( current_user.gender )
      redirect_to plans_path, alert: "既に募集が終了しています。" and return
    end

    if entry.present?
      if entry[:schedules].blank?
        redirect_to( plan_path( plan_id ), alert: "参加日を選択してください。" ) and return
      elsif entry[:comment].blank?
        redirect_to( plan_path( plan_id ), alert: "コメントを入力してください。" ) and return
      end

      new_entry = Entry.where(
        user_id: session[:user_id],
        plan_id: plan_id,
        comment: entry[:comment]
      ).first_or_create

      entry[:schedules].each_pair{ |key, value|
        Participation.where(
          user_id: session[:user_id],
          plan_id: plan_id,
          schedule_id: value,
          entry_id: new_entry.id
        ).first_or_create
      }
    end

    # 定員／最少開催人数チェック
    Plan.max_min_people_check( plan_id )

    redirect_to( plan_path( plan_id ), notice: "プランに参加しました。開催が決定しましたら「#{new_entry.user.email}」にお知らせが届きます。" )
  end

  #---------#
  # destroy #
  #---------#
  def destroy( plan_id, id )
    entry = Entry.where( user_id: session[:user_id], plan_id: plan_id, id: id ).first
    entry.destroy

    # 定員／最少開催人数チェック
    Plan.max_min_people_check( plan_id )

    redirect_to( plan_path( plan_id ), notice: "参加をキャンセルしました。" )
  end
end
