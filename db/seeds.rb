# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.where( name: "イベント" ).first_or_create
Category.where( name: "遊び" ).first_or_create
Category.where( name: "カラオケ" ).first_or_create
Category.where( name: "アウトドア" ).first_or_create
Category.where( name: "飲み会" ).first_or_create
