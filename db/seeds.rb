# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# カテゴリ
#Category.delete_all
Category.where( name: "カラオケ・アミューズメント", sort: 1 ).first_or_create
Category.where( name: "飲み会・食事会", sort: 2 ).first_or_create
Category.where( name: "スポーツ・アウトドア", sort: 3 ).first_or_create
Category.where( name: "インドアゲーム", sort: 4 ).first_or_create

# カウントキャッシュ再計算
Plan.includes( :cheers, :favorites ).all.each{ |plan|
  plan.update_attributes( cheers_count: plan.cheers.length, favorites_count: plan.favorites.length )
}

# 募集終了日時格納
Schedule.all.each{ |schedule|
  if schedule.candidate_day.present?
    schedule.close_at = schedule.candidate_day.end_of_day
    schedule.save
  end
}

# Userスラグ更新
User.all.each{ |u| u.update_attributes( nickname: u.nickname ) }

# -------------------------------------------------- #

# サンプルデータ
if Rails.env.development?
  1.upto(10){ |num|
    plan = Plan.where(
      title: "プラン#{num}",
      description: "プラン説明#{num}",
      place: "場所#{num}",
      budget: "予算#{num}",
      max_people: 10,
      min_people: 1
    ).first_or_create

    schedule = Schedule.new
    schedule.number        = 1
    schedule.plan_id       = plan.id
    schedule.candidate_day = Time.now.since(1.month)
    schedule.save
  }
end
