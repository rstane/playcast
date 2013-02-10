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
# Category.where( name: "イベント" ).first_or_create
# Category.where( name: "遊び" ).first_or_create
# Category.where( name: "カラオケ" ).first_or_create
# Category.where( name: "アウトドア" ).first_or_create
# Category.where( name: "飲み会" ).first_or_create
Category.where( name: "カラオケ・その他アミューズメント", sort: 1 ).first_or_create
Category.where( name: "飲み会・食事会", sort: 2 ).first_or_create
Category.where( name: "スポーツ", sort: 3 ).first_or_create
Category.where( name: "アウトドア遊び", sort: 4 ).first_or_create
Category.where( name: "インドアゲーム", sort: 5 ).first_or_create

# カウントキャッシュ再計算
Plan.includes( :cheers, :favorites ).all.each{ |plan|
  plan.update_attributes( cheers_count: plan.cheers.length, favorites_count: plan.favorites.length )
}
