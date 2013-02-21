# coding: utf-8
class TopController < ApplicationController
  #-------#
  # index #
  #-------#
  def index
    # # ログイン済みであればプラン一覧へ
    # if session[:user_id].present?
    #   redirect_to plans_path and return
    # end

    # 全てプラン一覧へ
    redirect_to plans_path and return
  end
end
