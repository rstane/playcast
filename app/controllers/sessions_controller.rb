# coding: utf-8
class SessionsController < ApplicationController

  #----------#
  # callback #
  #----------#
  def callback
    auth = request.env["omniauth.auth"]
#    puts "[ ---------- auth ---------- ]" ; auth.tapp ;
    user = User.where( provider: auth["provider"], uid: auth["uid"] ).first || User.create_with_omniauth( auth )

    # auth情報更新
    user.auth_update( auth )

    session[:user_id] = user.id

    # 保管URLへリダイレクト
    unless session[:request_url].blank?
      redirect_to session[:request_url]
      session[:request_url] = nil
      return
    end

    redirect_to plans_path
  end

  #---------#
  # destroy #
  #---------#
  def destroy
    session[:user_id] = nil

    redirect_to :root, notice: "ログアウトしました。"
  end

  #---------#
  # failure #
  #---------#
  def failure
    render text: "<span style='color: red;'>Auth Failure</span>"
  end

end
